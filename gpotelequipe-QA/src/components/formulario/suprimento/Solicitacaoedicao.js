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
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
//import InfoIcon from '@mui/icons-material/Info';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Mensagemescolha from '../../Mensagemescolha';
import Mensagemsimples from '../../Mensagemsimples';
import './textarea.css'; // Importe o arquivo CSS para estilização
import Solicitacaoedicaoitens from './Solicitacaoedicaoitens';
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';
//import Parcelas from '../parcelamento/Parcela';

const Solicitacaoedicao = ({
  setshow,
  show,
  ididentificador,
  atualiza,
  novo,
  numero,
  projetousual,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [idsolicitante, setidsolicitante] = useState('');
  const [solicitante, setsolicitante] = useState('');
  const [solicitacaoitenslista, setsolicitacaoitenslista] = useState([]);
  const [idsolicitacao, setidsolicitacao] = useState('');
  const [idsolicitacaoitem, setidsolicitacaoitem] = useState('');
  const [pageSize, setPageSize] = useState(5);
  const [telaprodutoitens, settelaprodutoitens] = useState('');
  const [telaprodutoitensedicao, settelaprodutoitensedicao] = useState('');
  const [titulo, settitulo] = useState('');
  const [titulomensagem, settitulomensagem] = useState('');
  const [mensagemdados, setmensagemdados] = useState('');
  const [telamensagem, settelamensagem] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  //const [idsolicitacoesitemlocal, setidsolicitacoesitemlocal] = useState('');
  const [currentDate, setcurrentDate] = useState('');
  const [observacao, setobservacao] = useState('');
  const [os, setos] = useState('');
  const [emailmaterial, setemailmaterial] = useState('');

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
    solicitacao: ididentificador,
    origem: 'SOLICITACAO',
    projeto: projetousual,
    obra: numero,
    deletado: 0,
  };


  async function loadingTable() {
    const response = await api.get('v1/emails/aviso');
    setemailmaterial(response.data.emailmaterial);
  }




  //Funções
  const listasolicatacaoitens = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacao/listaitens', { params }).then((response) => {
        setsolicitacaoitenslista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const atualizaitens = () => {
    listasolicatacaoitens();
  };

  //novo cadastro solicitação de itens vai para a tela solicitacaoedicaoitens
  const novocadastro = () => {
    api
      .post('v1/solicitacao/novocadastroitens', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidsolicitacaoitem(response.data.retorno);
          settitulo('Novo Item');
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
      .post('v1/solicitacao/editar', {
        idsolicitacao,
        numero: os,
        idsolicitante,
        observacao,
        currentDate,
        projetousual,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          api
            .post('v1/email/ordemservico', {
              dest: emailmaterial,
              assunto: `Aviso de Solicitação de Material - PROJETO ${projetousual || ''}`,
              osId: numero,
            })

          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
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

  const listaordemcompra = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid/lista', { params }).then((response) => {
        if (Object.keys(response.data).length === 0) {
          limpacampos();
        } else {
          setidsolicitacao(response.data.id);
          setsolicitante(response.data.nome);
          setcurrentDate(response.data.data);
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
    settelaexclusaosolicitacao(true);
    setidsolicitacaoitem(stat);
    listasolicatacaoitens();
    console.log(stat);
  }

  function alterarItens(stat) {
    settelaprodutoitensedicao(true);
    listasolicatacaoitens();
    setidsolicitacaoitem(stat);
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
          onClick={() => alterarItens(parametros.row.idsolicitacaoitens)}
        />,
        <GridActionsCellItem
          disabled={modoVisualizador()}
          icon={<DeleteIcon />}
          label="Delete"
          title="Delete"
          onClick={() => deleteUser(parametros.row.idsolicitacaoitens)}
        />,
      ],
    },
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'idproduto',
      headerName: 'Produto',
      width: 160,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'descricao',
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
    const date = new Date();
    const formattedDate = date.toISOString().split('T')[0];
    limpacampos();
    setidsolicitacao(ididentificador);
    setos(numero);
    loadingTable();
    if (novo === '0') {
      listaordemcompra();
      listasolicatacaoitens();
    } else {
      setsolicitante(localStorage.getItem('sessionNome'));
      setidsolicitante(localStorage.getItem('sessionId'));
      setcurrentDate(formattedDate);
    }
  };

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
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        Solicitação de Material
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
              <div className="col-2">
                Nº
                <Input type="text" value={idsolicitacao} placeholder="" disabled />
              </div>
              <div className="col-sm-6">
                Solicitante
                <InputGroup className="comprimento-group">
                  <Input type="hidden" value={idsolicitante} name="idsolicitante" />
                  <Input type="text" value={solicitante} name="status" disabled />
                </InputGroup>
              </div>
              <div className="col-2">
                Data Solicitação
                <Input
                  type="date"
                  value={currentDate.toLocaleString()}
                  onChange={(e) => setcurrentDate(e.target.value)}
                  placeholder=""
                  disabled
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
                  <Icon.PlusCircle /> Adicionar Item
                </Button>
              </div>
            </div>
            {telaprodutoitens ? (
              <>
                <Solicitacaoedicaoitens
                  show={telaprodutoitens}
                  setshow={settelaprodutoitens}
                  ididentificador={idsolicitacao}
                  idsolicitacoesitemlocal={idsolicitacaoitem}
                  atualiza={atualizaitens}
                  titulotopo={titulo}
                />
              </>
            ) : null}
            {telaprodutoitensedicao ? (
              <>
                <Solicitacaoedicaoitens
                  show={telaprodutoitensedicao}
                  setshow={settelaprodutoitensedicao}
                  ididentificador={idsolicitacao}
                  idsolicitacoesitemlocal={idsolicitacaoitem}
                  atualiza={atualizaitens}
                  titulotopo="Alterar Item"
                />
              </>
            ) : null}
            {telaexclusaosolicitacao ? (
              <>
                <Excluirregistro
                  show={telaexclusaosolicitacao}
                  setshow={settelaexclusaosolicitacao}
                  ididentificador={idsolicitacaoitem}
                  quemchamou="SOLICITACAOITENS"
                  atualiza={atualizaitens}
                  idlojaatual={localStorage.getItem('sessionloja')}
                />{' '}
              </>
            ) : null}
            <Box sx={{ height: 400, width: '100%' }}>
              <DataGrid
                rows={solicitacaoitenslista}
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
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Solicitacaoedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  novo: PropTypes.string,
  numero: PropTypes.string,
  projetousual: PropTypes.string,
};

export default Solicitacaoedicao;
