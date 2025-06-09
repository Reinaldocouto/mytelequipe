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
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
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

  //Parametros
  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
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

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 110,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
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
      ],
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
                <Button color="primary" onClick={() => novocadastro()} disabled={modoVisualizador()}>
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
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
