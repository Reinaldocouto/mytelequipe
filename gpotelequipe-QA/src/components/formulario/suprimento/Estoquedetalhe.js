import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input, Label } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  //GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import * as Icon from 'react-feather';
//import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import Estoquelancamento from './Estoquelancamento';
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';

const Estoquedetalhe = ({ setshow, show, ididentificador, descricao }) => {
  const [mensagem, setmensagem] = useState('');
  const [loading, setLoading] = useState(false);
  const [controleestoque, setcontroleestoque] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [titulo, settitulo] = useState('');
  const [identificador, setidentificador] = useState(0);
  const [idproduto, setidproduto] = useState(0);
  const [lancamentoestoque, setlancamentoestoque] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [lancamento, setlancamento] = useState(0);
  const [entrada, setentrada] = useState(0);
  const [saida, setsaida] = useState(0);
  const [saldofisico, setsaldofisico] = useState(0);
  const [reservado, setreservado] = useState(0);
  const [estoquedisponivel, setestoquedisponivel] = useState(0);

  const togglecadastro = () => {
    setshow(!show);
  };

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
        onChange={(event, value) => apiRef.current.setPage(value - 1)}
      />
    );
  }

  //Funções
  const listaestoquestatus = async () => {
    try {
      setLoading(true);
      await api.get('v1/controleestoquedetalhestatus', { params }).then((response) => {
        setlancamento(response.data.lancamentos);
        setentrada(response.data.entradas);
        setsaida(response.data.saidas);
        setsaldofisico(response.data.saldofisico);
        setreservado(response.data.reservados);
        setestoquedisponivel(response.data.estoquedisponivel);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const listaestoque = async () => {
    try {
      setLoading(true);
      await api.get('v1/controleestoquedetalhe', { params }).then((response) => {
        setcontroleestoque(response.data);
        setmensagem('');
        listaestoquestatus();
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      field: 'dataehora',
      headerName: 'Data e Hora',
      type: 'string',
      width: 170,
      align: 'center',
      editable: false,
    },
    {
      field: 'entrada',
      headerName: 'Entrada',
      type: 'number',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'saida',
      headerName: 'Saida',
      type: 'number',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'balanco',
      headerName: 'Balanço',
      type: 'number',
      width: 100,
      align: 'right',
      editable: false,
    },
    {
      field: 'valor',
      headerName: 'Valor',
      type: 'number',
      width: 150,
      align: 'right',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'Observacao',
      type: 'string',
      width: 350,
      align: 'left',
      editable: false,
    },
    {
      field: 'tipomovimento',
      headerName: 'Movimento',
      type: 'string',
      width: 100,
      align: 'center',
      editable: false,
    },
  ];

  const novocadastro = () => {
    api
      .post('v1/controleestoquelancamento/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidentificador(response.data.retorno);
          setlancamentoestoque(true);
          setidproduto(ididentificador);
          settitulo('Lançamento');
        } else {
          setmensagem(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const iniciatabelas = () => {
    listaestoque();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl  modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro} style={{ backgroundColor: 'white' }}>
        Controle de Estoque - Lançamentos
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {lancamentoestoque && (
          <>
            {' '}
            <Estoquelancamento
              show={lancamentoestoque}
              setshow={setlancamentoestoque}
              ididentificador={identificador}
              idprodutodetalhe={idproduto}
              atualiza={listaestoque}
              titulotopo={titulo}
            />{' '}
          </>
        )}
        {telaexclusao ? (
          <>
            <Excluirregistro
              show={telaexclusao}
              setshow={settelaexclusao}
              ididentificador={identificador}
              quemchamou="CONTROLEESTOQUEDETALHE"
              atualiza={listaestoque}
              idlojaatual={localStorage.getItem('sessionloja')}
            />{' '}
          </>
        ) : null}
        {loading ? (
          <Loader />
        ) : (
          <>
            <div className="row g-3">
              <div className="col-sm-9">
                <Label>{descricao}</Label>
              </div>
              <div className="col-sm-3 d-flex flex-row-reverse">
                <Button
                  color="primary"
                  onClick={() => novocadastro()}
                  disabled={modoVisualizador()}
                >
                  Incluir Lançamento <Icon.Plus />
                </Button>
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <Box sx={{ height: 360, width: '100%' }}>
                <DataGrid
                  rows={controleestoque}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress }}
                />
              </Box>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-2">
                Lançamentos
                <Input
                  type="number"
                  value={lancamento}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-2">
                Entradas
                <Input
                  type="number"
                  value={entrada}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-2">
                Saidas
                <Input
                  type="number"
                  value={saida}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-2">
                Saldo Fisico
                <Input
                  type="number"
                  value={saldofisico}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-2">
                Reservado
                <Input
                  type="number"
                  value={reservado}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
              <div className="col-sm-2">
                Estoque Disponivel
                <Input
                  type="number"
                  value={estoquedisponivel}
                  placeholder=""
                  disabled
                  style={{ backgroundColor: 'white' }}
                />
              </div>
            </div>
          </>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Estoquedetalhe.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  descricao: PropTypes.string,
};

export default Estoquedetalhe;
