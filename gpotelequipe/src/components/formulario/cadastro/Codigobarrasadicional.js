import { useState, useEffect } from 'react';
import {
  Button,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Row,
  Col,
  FormGroup,
  Label,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import * as Icon from 'react-feather';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import PropTypes from 'prop-types';
import Loader from '../../../layouts/loader/Loader';
import Excluirregistro from '../../Excluirregistro';
import api from '../../../services/api';
import modoVisualizador from '../../../services/modovisualizador';

const Codigobarrasadicional = ({ setshow, show, ididentificador, atualiza, titulotopo }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [barras, setbarras] = useState('');
  const [barraslista, setbarraslista] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [telaexclusaobarras, settelaexclusaobarras] = useState();
  const [identificador, setidentificador] = useState();
  const [barrasprincipal, setbarrasprincipal] = useState('');

  console.log(atualiza);
  console.log(setmensagem);
  console.log(setmensagemsucesso);
  console.log(setloading);

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idprodutobusca: ididentificador,
    deletado: 0,
  };

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="secondary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
      />
    );
  }

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function deletebarras(stat) {
    settelaexclusaobarras(true);
    setidentificador(stat);
    console.log(stat);
  }

  const togglecadastro = () => {
    setshow(!show);
  };

  const codigobarras = () => {
    api.get('v1/barras', { params }).then((response) => {
      setbarraslista(response.data);
    });
  };

  function processabarras(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');

    //verifica se o barras é válido
    if (!barras) {
      setmensagem('O campo Código de Barras é obrigatório');
      return;
    }

    api
      .post('v1/barras', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idproduto: ididentificador,
        barras,
        barrasprincipal,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          codigobarras();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      });
  }

  //tabela barras adicional
  const barrascolunas = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          title="Apagar barras"
          onClick={() => deletebarras(parametros.id)}
        />,
      ],
    },
    {
      field: 'barras',
      headerName: 'Código de Barras Adicional',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 'barrasprincipal',
      headerName: 'Código de Barras Principal',
      width: 300,
      type: 'boolean',
      align: 'center',
      editable: false,
    },
  ];

  console.log(params);

  const iniciatabelas = () => {
    codigobarras();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-lg modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>{titulotopo}</ModalHeader>
      <ModalBody>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            {' '}
            Registro Salvo
          </div>
        ) : null}

        {telaexclusaobarras && (
          <>
            <Excluirregistro
              show={telaexclusaobarras}
              setshow={settelaexclusaobarras}
              ididentificador={identificador}
              quemchamou="CODIGOBARRAS"
              atualiza={codigobarras}
              idlojaatual={localStorage.getItem('sessionloja')}
            />{' '}
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <>
            <Row>
              <Col md="12">
                <FormGroup>
                  <div className="row g-3">
                    <div className="col-sm-3">
                      Código de Barras
                      <Input
                        type="text"
                        onChange={(e) => setbarras(e.target.value)}
                        value={barras}
                      ></Input>
                    </div>
                    <div className="col-sm-4">
                      <br></br>
                      <FormGroup check>
                        <Input
                          type="checkbox"
                          id="check1"
                          checked={barrasprincipal}
                          onChange={(e) => setbarrasprincipal(e.target.checked)}
                        />
                        <Label check>Código de Barras Principal</Label>
                      </FormGroup>
                    </div>
                    <div className="col-sm-5">
                      <p />
                      <div className="d-flex flex-row-reverse">
                        <Button
                          color="primary"
                          onClick={processabarras}
                          disabled={modoVisualizador()}
                        >
                          Adicionar <Icon.Plus />
                        </Button>
                      </div>
                    </div>
                  </div>
                </FormGroup>
              </Col>
            </Row>
            <Row>
              <Box sx={{ height: 350, width: '100%' }}>
                <DataGrid
                  rows={barraslista}
                  columns={barrascolunas}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{ Pagination: CustomPagination, NoRowsOverlay: CustomNoRowsOverlay }}
                  //opções traduzidas da tabela
                  localeText={{
                    // Column menu text
                    columnMenuShowColumns: 'Mostra Colunas',
                    columnMenuManageColumns: 'Gerencia Colunas',
                    columnMenuFilter: 'Filtro',
                    columnMenuHideColumn: 'Esconder',
                    columnMenuUnsort: 'Desordenar',
                    columnMenuSortAsc: 'Classificar por Crescente',
                    columnMenuSortDesc: 'Classificar por Decrescente',
                  }}
                />
              </Box>
            </Row>
          </>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Codigobarrasadicional.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
};

export default Codigobarrasadicional;
