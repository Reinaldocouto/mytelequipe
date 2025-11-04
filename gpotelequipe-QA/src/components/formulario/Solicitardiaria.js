import { useState, useEffect } from 'react';
import {
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  InputGroup,
} from 'reactstrap';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  selectedIdsLookupSelector,
} from '@mui/x-data-grid';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import EditIcon from '@mui/icons-material/Edit';
import Select from 'react-select';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
//import InfoIcon from '@mui/icons-material/Info';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import api from '../../services/api';
import Loader from '../../layouts/loader/Loader';
import Mensagemescolha from '../Mensagemescolha';
import Mensagemsimples from '../Mensagemsimples';
 import modoVisualizador from '../../services/modovisualizador';
//import Parcelas from '../parcelamento/Parcela';
const Solicitardiaria = ({ setshow, show, ididentificador, atualiza, novo, numero }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [idsolicitante, setidsolicitante] = useState('');
  const [solicitante, setsolicitante] = useState('');
  const [datasol, setdatasol] = useState('');
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [ordemcompraitenslista, setordemcompraitenslista] = useState([]);
  const [idsolicitacao, setidsolicitacao] = useState('');
  const [pageSize, setPageSize] = useState(5);
  const [telaprodutoitens, settelaprodutoitens] = useState('');
  const [telaprodutoitensedicao, settelaprodutoitensedicao] = useState('');
  const [titulomensagem, settitulomensagem] = useState('');
  const [mensagemdados, setmensagemdados] = useState('');
  const [telamensagem, settelamensagem] = useState('');
  /*
      const [nitens, setnitens] = useState(0);
      const [somaqtdes, setsomaqtdes] = useState(0);
      const [totalprodutos, settotalprodutos] = useState(0);
      const [desconto, setdesconto] = useState(0);
      const [frete, setfrete] = useState(0);
      const [totalipi, settotalipi] = useState(0);
      const [totalicmsst, settotalicmsst] = useState(0);
      const [totalgeral, settotalgeral] = useState(0);
      const [dataprevista, setdataprevista] = useState('');
      const [numerofornecedor, setnumerofornecedor] = useState(0);
      const [datacompra, setdatacompra] = useState('');
      const [idtransportadora, setidtransportadora] = useState('');
      const [idtipofrete, setidtipofrete] = useState('');
       */
  const [observacao, setobservacao] = useState('');

  //const [numero, setnumero] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idnome: localStorage.getItem('sessionNome'), //localStorage.setItem('sessionNome', response.data.nome);
    //idpedido: ididentificador,
    origem: 'PEDIDOCOMPRA',
    obra: numero,
    deletado: 0,
  };

  //Funções
  const listaordemcompraitens = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoo/itens', { params }).then((response) => {
        setordemcompraitenslista(response.data);

        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectcolaboradorclt', { params }).then((response) => {
        setcolaboradorcltlista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  //novo cadastro solicitação de itens vai para a tela solicitacaoedicaoitens
  const novocadastro = () => {
    api
      .post('v1/ordemcompra/novocadastroitens', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          // setidordemcompraitemlocal(response.data.retorno); //identificador
          //settitulo('Novo Item');
          settelaprodutoitens(true);
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

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/solicitacao', {
        idordemcompra: ididentificador,
        numero: ididentificador,
        idsolicitante,
        observacao,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          console.log(atualiza());
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

  function limpacampos() {
    //setnitens('0');
    // setsomaqtdes('0.00');
    // settotalprodutos('0.00');
    //setdesconto('0.00');
    //setfrete('0.00');
    //settotalipi('0.00');
    //settotalicmsst('0.00');
    //settotalgeral('0.00');
  }

  const handleChangecolaboradorclt = (stat) => {
    if (stat !== null) {
      setidcolaboradorclt(stat.value);
      setselectedoptioncolaboradorclt({ value: stat.value, label: stat.label });
    } else {
      setidcolaboradorclt(0);
      setselectedoptioncolaboradorclt({ value: null, label: null });
    }
  };

  const listaordemcompra = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid', { params }).then((response) => {
        if (Object.keys(response.data).length === 0) {
          limpacampos();
        } else {
          setidsolicitacao(response.data.idsolicitacao);
          setsolicitante(response.data.idsolicitante);
          setobservacao(response.data.observacao);
        }
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function deleteUser(stat) {
    //settelaexclusao(true);
    //setididentificador(stat);
    //listacompras();
    console.log(stat);
  }

  function alterarItens(stat) {
    settelaprodutoitensedicao(true);
    listaordemcompraitens();
    //setidordemcompraitemlocal(stat);
    console.log(stat);
  }

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);

    return (
      <Pagination
        color="primary"
        count={pageCount}
        page={page + 1}
        onChange={(event, value) => apiRef.current.setPage(value - 1)}
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

  //tabela de edição de  itens
  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 120,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          title="Alterar"
          onClick={() => alterarItens(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'idproduto',
      headerName: 'Produto',
      width: 420,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'quantidade',
      headerName: 'Quantidade',
      width: 150,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'unidade',
      headerName: 'Unidade',
      width: 150,
      align: 'center',
      type: 'string',
      editable: false,
    },
  ];

  function confirmacao(resposta) {
    //  setmensagemmostrar(true);
    if (resposta === 1) {
      //  setverparcelas(false);
      // setcondicaopagamento('');
      // setdesabilita(false);
      settitulomensagem('Sucesso');
      setmensagemdados('Sucesso');
      settelamensagem(true);
    }
  }

  const iniciatabelas = () => {
    limpacampos();
    setidsolicitacao(ididentificador);
    console.log(ididentificador);
    listacolaboradorclt();
    setsolicitante(localStorage.getItem('sessionNome'));
    setidsolicitante(localStorage.getItem('sessionId'));
    if (novo === '0') {
      listaordemcompraitens();
      listaordemcompra();
    }
  };

  console.log();
  console.log(selectedIdsLookupSelector);
  console.log(setidsolicitante);

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>Solicitação de Diária</ModalHeader>
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
        {telamensagem && (
          <>
            {' '}
            <Mensagemsimples
              show={telamensagem}
              setshow={settelamensagem}
              mensagem={mensagemdados}
              titulo={titulomensagem}
            />{' '}
          </>
        )}
        {mensagemmostrar && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Confirmação"
              mensagem="O Parcelamento anterior será apagado. Deseja realmente editar o parcelamento? "
              respostapergunta={confirmacao}
            />{' '}
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-1">
                Nº
                <Input type="text" value={idsolicitacao} placeholder="" disabled />
              </div>
              <div className="col-sm-3">
                Solicitante
                <InputGroup className="comprimento-group">
                  <Input type="hidden" value={idsolicitante} name="idsolicitante" />
                  <Input type="text" value={solicitante} name="status" disabled />
                </InputGroup>
              </div>

              <div className="col-sm-2">
                Dt Solicitação
                <Input type="date" onChange={(e) => setdatasol(e.target.value)} value={datasol} />
              </div>

              <div className="col-sm-1">
                Hr Solicitação
                <Input type="time" onChange={(e) => setdatasol(e.target.value)} value={datasol} />
              </div>

              <div className="col-sm-5">
                Colaborador
                <Input
                  type="hidden"
                  onChange={(e) => setidcolaboradorclt(e.target.value)}
                  value={idcolaboradorclt}
                  name="idcolaborador"
                />
                <Select
                  isClearable
                  isSearchable
                  name="colaboradorclt"
                  options={colaboradorcltlista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleChangecolaboradorclt}
                  value={selectedoptioncolaboradorclt}
                />
              </div>
            </div>
            <hr />
            <div className="row g-3">
              <div className="col-sm-4 d-md-flex align-items-center gap-2 ">
                <b>Listagem</b>
              </div>
              <div className="col-sm-8 d-md-flex align-items-center gap-2 d-flex flex-row-reverse">
                <Button color="link" onClick={novocadastro}>
                  {' '}
                  <Icon.PlusCircle /> Adicionar Item{' '}
                </Button>
              </div>
            </div>
            {telaprodutoitens ? <> </> : null}
            {telaprodutoitensedicao ? <> </> : null}
            <Box sx={{ height: 400, width: '100%' }}>
              <DataGrid
                rows={ordemcompraitenslista}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
                  NoRowsOverlay: CustomNoRowsOverlay,
                }}
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
            <br></br>
            <div className="row g-3">
              <div className="col-sm-12">
                <b>Observações</b>
                <Input
                  type="textarea"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                  placeholder=""
                />
              </div>
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Solicitardiaria.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  novo: PropTypes.string,
  numero: PropTypes.string,
};

export default Solicitardiaria;
