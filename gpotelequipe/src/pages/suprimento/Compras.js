import { useState, useEffect } from 'react';
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
import {
  Card,
  CardBody,
  CardTitle,
  Button,
  Input,
  InputGroup,
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Form,
  FormGroup,
  Label,
} from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Brightness1Icon from '@mui/icons-material/Brightness1';
import PaidIcon from '@mui/icons-material/Paid';
import NoteAddIcon from '@mui/icons-material/NoteAdd';
import BookmarkAddIcon from '@mui/icons-material/BookmarkAdd';
import BookmarkRemoveIcon from '@mui/icons-material/BookmarkRemove';
import SearchIcon from '@mui/icons-material/Search';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import Chip from '@mui/material/Chip'; //{ ChipProps }
import { red, blue, green, amber, grey } from '@mui/material/colors';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import api from '../../services/api';
import Excluirregistro from '../../components/Excluirregistro';
import Comprasedicao from '../../components/formulario/suprimento/Comprasedicao';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';
import Mensagemescolha from '../../components/Mensagemescolha';
import modoVisualizador from '../../services/modovisualizador';

export default function Compras() {
  const [compras, setcompras] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [loading, setLoading] = useState(false);
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [ididentificador, setididentificador] = useState(0);
  const [titulo, settitulo] = useState('');
  const [permission, setpermission] = useState(0);
  const [mensagemmostrardel, setmensagemmostrardel] = useState(false);
  const [mensagemmostrardel1, setmensagemmostrardel1] = useState(false);
  const [showApprovalModal, setShowApprovalModal] = useState(false);
  const [selectedRequest, setSelectedRequest] = useState(null);
  const [ordemcompraitenslista, setordemcompraitenslista] = useState([]);
  const [loadingItensProduto, setLoadingItemsProduto] = useState([]);
  //Parametros
  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    nomeUsuario: localStorage.getItem('sessionNome'),
  };

  const novocadastro = () => {
    api
      .post('v1/ordemcompra/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastrar Ordem de Compra');
          settelacadastro(true);
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

  const listacompras = async () => {
    try {
      setLoading(true);
      await api.get('/v1/ordemcompra', { params }).then((response) => {
        setcompras(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  const mudarstatus = (idordemcompralocal, situacaolocal) => {
    api
      .post('v1/ordemcompra/mudarstatus', {
        idordemcompra: idordemcompralocal,
        situacao: situacaolocal,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          listacompras();
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

  function limparfiltro() {
    listacompras();
  }

  function deleteUser(stat) {
    settelaexclusao(true);
    setididentificador(stat);
    listacompras();
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.compras === 1);
  }

  function alterarUser(stat) {
    settitulo('Editar Ordem de Compra');
    settelacadastroedicao(true);
    setididentificador(stat);
    listacompras();
  }

  function confirmacaodel(resposta) {
    setmensagemmostrardel(false);
    if (resposta === 1) {
      api
        .post('v1/ordemcompra/lancarestoque', {
          idordemcompra: ididentificador,
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
        })
        .then((response) => {
          if (response.status === 201) {
            listacompras();
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
    }
  }

  const gerarRelatorioCompleto = () => {
    const excelData = compras.map((item) => {
      return {
        Número: item.id,
        Solicitação: item.idordemcompra,
        Situação: item.situacao,
        Fornecedor: item.fornecedor,
        Solicitante: item.solicitante,
        'Data da solicitação': item.datasolicitacao,
        'Data pedido da compra': item.data1,
        Previsto: item.dataprevisto1,
        Frete: item.frete,
        Marcadores: item.marcadores,
        Observacoes: item.observacoes,
        TotalProdutos: item.totalprodutos,
        Desconto: item.desconto,
        TotalIPI: item.totalipi,
        TotalICMSST: item.totalicmsst,
        ObservacoesInterna: item.observacoesinterna,
        LancarEstoque: item.lancarestoque,
        Total: item.totalgeral,
      };
    });
    exportExcel({ excelData, fileName: 'relatorio_de_compras_completo' });
  };

  function confirmacaodel1(resposta) {
    setmensagemmostrardel1(false);
    if (resposta === 1) {
      api
        .post('v1/ordemcompra/cancelarlancarestoque', {
          idordemcompra: ididentificador,
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
        })
        .then((response) => {
          if (response.status === 201) {
            listacompras();
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
    }
  }

  function lancarestoque(stat) {
    setididentificador(stat);
    setmensagemmostrardel(true);
  }

  function cancelarlancarestoque(stat) {
    setididentificador(stat);
    setmensagemmostrardel1(true);
  }

  function statusaberto(stat) {
    mudarstatus(stat, 'EM ABERTO');
  }
  function statusandamento(stat) {
    mudarstatus(stat, 'EM ANDAMENTO');
  }
  function statusatendido(stat) {
    mudarstatus(stat, 'ATENDIDO');
  }
  function statuscancelado(stat) {
    mudarstatus(stat, 'CANCELADO');
  }
  const handleApproval = async () => {
    try {
      const response = await api.post('v1/ordemcompra/aprovacao', {
        idordemcompra: selectedRequest.id,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        aprovadopor: params.nomeUsuario,
      });

      if (response.status === 201) {
        setmensagem('');
        setShowApprovalModal(false);
        listacompras();
      }
    } catch (err) {
      setmensagem(err.response?.data?.erro || 'Erro ao aprovar ordem de compra');
    }
  };
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

  function getChipProps(params1) {
    switch (params1) {
      case 'EM ABERTO':
        return {
          icon: <Brightness1Icon style={{ fill: blue[500] }} />,
          label: 'Aberto',
          style: {
            borderColor: blue[900],
          },
        };
      case 'EM ANDAMENTO':
        return {
          icon: <Brightness1Icon style={{ fill: amber[500] }} />,
          label: 'Andamento',
          style: {
            borderColor: amber[900],
          },
        };
      case 'ATENDIDO':
        return {
          icon: <Brightness1Icon style={{ fill: green[500] }} />,
          label: 'Atendido',
          style: {
            borderColor: green[900],
          },
        };
      case 'CANCELADO':
        return {
          icon: <Brightness1Icon style={{ fill: '#262626'[500] }} />,
          label: 'Cancelado',
          style: {
            borderColor: grey[900],
          },
        };
      default:
        return {
          icon: <Brightness1Icon style={{ fill: red[500] }} />,
          label: 'ERRO',
          style: {
            borderColor: red[500],
          },
        };
    }
  }
  const listaordemcompraitens = async (id) => {
    try {
      setLoadingItemsProduto(true);
      params.idpedido = id;
      params.idordemcomprabusca = id;
      await api.get('v1/ordemcompra/itens', { params }).then((response) => {
        setordemcompraitenslista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoadingItemsProduto(false);
    }
  };
  const openApprovalModal = (paramsopen) => {
    listaordemcompraitens(paramsopen.id);
    paramsopen.row = { ...paramsopen.row, ...params };
    // paramsopen.row.aprovadopor = localStorage.getItem('sessionNome');
    setSelectedRequest(paramsopen.row);
    setShowApprovalModal(true);
  };

  const columnsItems = [
    //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
    {
      field: 'produto',
      headerName: 'Produto',
      width: 320,
      align: 'left',
      type: 'string',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'codigosku',
      headerName: 'Cod(SKU)',
      width: 130,
      align: 'left',
      type: 'string',
      editable: false,
    },
    {
      field: 'quantidade',
      headerName: 'Qtde',
      width: 120,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'unidade',
      headerName: 'Unid',
      width: 120,
      align: 'center',
      type: 'string',
      editable: false,
    },
    {
      field: 'preco',
      headerName: 'Preço un',
      width: 140,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'ipi',
      headerName: 'IPI%',
      width: 100,
      align: 'right',
      type: 'number',
      editable: false,
    },
    {
      field: 'valortotal',
      headerName: 'Preço Total',
      width: 150,
      align: 'right',
      type: 'number',
      editable: false,
    },
  ];

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 110,
      align: 'center',
      getActions: (parametros) => {
        const actions = [];
        console.log(parametros.row);
        if (parametros.row.statuscompraaprovada !== 'Aprovado') {
          actions.push(
            <GridActionsCellItem
              icon={<CheckCircleIcon />}
              label="Aprovar"
              title="Aprovar Requisição"
              onClick={() => openApprovalModal(parametros)}
            />,
          );
        }
        actions.push(
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Alterar"
            onClick={() => alterarUser(parametros.id)}
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            disabled={modoVisualizador()}
            label="Deletar"
            onClick={() => deleteUser(parametros.id)}
            showInMenu={parametros.row.statuscompraaprovada !== 'Aprovado'}
          />,
          <GridActionsCellItem
            icon={<Brightness1Icon style={{ fill: blue[500] }} />}
            label="Em Aberto"
            onClick={() => statusaberto(parametros.id)}
            showInMenu
          />,
          <GridActionsCellItem
            icon={<Brightness1Icon style={{ fill: amber[500] }} />}
            label="Em Andamento"
            onClick={() => statusandamento(parametros.id)}
            showInMenu
          />,
          <GridActionsCellItem
            icon={<Brightness1Icon style={{ fill: green[500] }} />}
            label="Atendido"
            onClick={() => statusatendido(parametros.id)}
            showInMenu
          />,
          <GridActionsCellItem
            icon={<Brightness1Icon style={{ fill: '#262626'[500] }} />}
            label="Cancelado"
            onClick={() => statuscancelado(parametros.id)}
            showInMenu
          />,

          /*   <GridActionsCellItem
              icon={<NoteAddIcon />}
              label="Gerar Nota Fiscal"
              onClick={() => alterarUser(parametros.id)}
              showInMenu
              disabled
             <GridActionsCellItem
              icon={<PaidIcon />}
              label="Lançar Contas a Pagar"
              onClick={() => alterarUser(parametros.id)}
              showInMenu
            />, */
          <GridActionsCellItem
            icon={<BookmarkAddIcon />}
            label="Lançar Estoque"
            onClick={() => lancarestoque(parametros.id)}
            showInMenu
          />,
          <GridActionsCellItem
            icon={<BookmarkRemoveIcon />}
            label="Cancelar Lançamento de Estoque"
            onClick={() => cancelarlancarestoque(parametros.id)}
            showInMenu
          />,
          /* <GridActionsCellItem
           icon={<PostAddIcon />}
           label="Clonar Ordem de Compra"
           onClick={() => alterarUser(parametros.id)}
           showInMenu
           disabled
         />, 
         <GridActionsCellItem
           icon={<PostAddIcon />}
           label="Imprimir"
           onClick={() => alterarUser(parametros.id)}
           showInMenu
           disabled
         />, */
        );
        return actions;
      },
    },
    {
      field: 'situacao',
      headerName: 'Situação',
      width: 110,
      align: 'rigth',
      editable: false,
      renderCell: (parametros) => {
        return <Chip variant="outlined" size="small" {...getChipProps(parametros.value)} />;
      },
    },
    { field: 'id', headerName: 'Pedido', width: 80, align: 'center' },
    {
      field: 'data',
      headerName: 'Data',
      width: 110,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'dataprevisto',
      headerName: 'Previsto',
      width: 110,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'aprovadopor',
      headerName: 'Aprovado por',
      width: 260,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'dataaprovacao',
      headerName: 'Data aprovação',
      width: 260,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'statuscompraaprovada',
      headerName: 'Status da Compra',
      width: 260,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'fornecedor',
      headerName: 'Fornecedor',
      width: 260,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'total',
      headerName: 'Valor Total',
      type: 'number',
      width: 140,
      align: 'right',
      editable: false,
    },
    {
      field: 'marcadores',
      headerName: 'Marcadores',
      type: 'actions',
      width: 150,
      align: 'center',
      getActions: (opcoes) => [
        <GridActionsCellItem
          icon={<NoteAddIcon style={{ fill: grey[300 * 0 + 200] }} />}
          title="Nota Fiscal"
        />,
        <GridActionsCellItem
          icon={<PaidIcon style={{ fill: grey[200] }} />}
          title="Contas a Pagar"
        />,
        <GridActionsCellItem
          icon={<BookmarkAddIcon style={{ fill: grey[300 * opcoes.row.lancarestoque + 200] }} />}
          title="Lançar Estoque"
        />,
      ],
    },
  ];

  const modalAprovacao = () => {
    return (
      <Modal
        isOpen={showApprovalModal}
        toggle={() => setShowApprovalModal(false)}
        className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
      >
        <ModalHeader toggle={() => setShowApprovalModal(false)}>
          Aprovar Ordem de Compra
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label>Será aprovado por</Label>
              <Input type="text" value={selectedRequest?.nomeUsuario || ''} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Data Compra</Label>
              <Input type="text" value={selectedRequest?.data || ''} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Data Prevista</Label>
              <Input type="text" value={selectedRequest?.dataprevisto || ''} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Fornecedor</Label>
              <Input type="text" value={selectedRequest?.fornecedor || ''} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Situação</Label>
              <Input type="text" value={selectedRequest?.situacao || ''} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Lançado no Estoque</Label>
              <Input type="text" value={selectedRequest?.lancarestoque ? 'Sim' : 'Não'} disabled />
            </FormGroup>
            <FormGroup>
              <Label>Marcadores</Label>
              <Input type="text" value={selectedRequest?.marcadores || 'Nenhum'} disabled />
            </FormGroup>
            <Box sx={{ height: 300, width: '100%' }}>
              <DataGrid
                rows={ordemcompraitenslista}
                columns={columnsItems}
                loading={loadingItensProduto}
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
            <FormGroup>
              <Label>Total</Label>
              <Input type="text" value={selectedRequest?.total || ''} disabled />
            </FormGroup>
          </Form>
        </ModalBody>
        <ModalFooter>
          <Button color="primary" onClick={handleApproval}>
            Aprovar
          </Button>
          <Button color="secondary" onClick={() => setShowApprovalModal(false)}>
            Cancelar
          </Button>
        </ModalFooter>
      </Modal>
    );
  };

  const iniciatabelas = () => {
    listacompras();
  };

  const gerarexcel = () => {
    const excelData = compras.map((item) => {
      console.log(item);
      return {
        Situação: item.situacao,
        ID: item.id,
        Data: item.data,
        Previsto: item.dataprevisto,
        Fornecedor: item.fornecedor,
      };
    });
    exportExcel({ excelData, filename: 'compras' });
  };
  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);
  return (
    <div>
      {permission && (
        <div>
          {modalAprovacao()}

          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Ordens de Compra
              </CardTitle>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              <div className="row g-3">
                <div className="col-sm-6">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por Fornecedor"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Button color="primary" onClick={() => listacompras()}>
                      {' '}
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      {' '}
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>
                <div className=" col-sm-6 d-flex flex-row-reverse">
                  <Button
                    color="primary"
                    onClick={() => novocadastro()}
                    disabled={modoVisualizador()}
                  >
                    Adicionar <Icon.Plus />
                  </Button>
                  {telacadastro ? (
                    <Comprasedicao
                      show={telacadastro}
                      setshow={settelacadastro}
                      ididentificador={ididentificador}
                      atualiza={listacompras}
                      titulotopo={titulo}
                    />
                  ) : null}
                  {telacadastroedicao ? (
                    <>
                      {' '}
                      <Comprasedicao
                        show={telacadastroedicao}
                        setshow={settelacadastroedicao}
                        ididentificador={ididentificador}
                        atualiza={listacompras}
                        titulotopo={titulo}
                      />{' '}
                    </>
                  ) : null}
                  {mensagemmostrardel && (
                    <>
                      {' '}
                      <Mensagemescolha
                        show={mensagemmostrardel}
                        setshow={setmensagemmostrardel}
                        titulotopo="Lançar Estoque"
                        mensagem="Deseja realmente lançar o estoque desse pedido?"
                        respostapergunta={confirmacaodel}
                      />{' '}
                    </>
                  )}
                  {mensagemmostrardel1 && (
                    <>
                      {' '}
                      <Mensagemescolha
                        show={mensagemmostrardel1}
                        setshow={setmensagemmostrardel1}
                        titulotopo="Cancelar Lançamento de Estoque"
                        mensagem="Deseja realmente cancelar o lançamento do estoque desse pedido?"
                        respostapergunta={confirmacaodel1}
                      />{' '}
                    </>
                  )}
                  {telaexclusao ? (
                    <>
                      <Excluirregistro
                        show={telaexclusao}
                        setshow={settelaexclusao}
                        ididentificador={ididentificador}
                        quemchamou="COMPRAS"
                        atualiza={listacompras}
                        idlojaatual={localStorage.getItem('sessionloja')}
                      />{' '}
                    </>
                  ) : null}
                </div>
              </div>
              <br></br>
              <Button color="link" onClick={() => gerarexcel()}>
                {' '}
                Exportar Excel
              </Button>
              <Button color="link" onClick={() => gerarRelatorioCompleto()}>
                {' '}
                Exportar Relatório Geral de Compras
              </Button>

              <Box sx={{ height: compras.length > 6 ? '100%' : 500, width: '100%' }}>
                {' '}
                <DataGrid
                  rows={compras}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  //rowsPerPageOptions={[10]}
                  //checkboxSelection
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
            </CardBody>
          </Card>
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
