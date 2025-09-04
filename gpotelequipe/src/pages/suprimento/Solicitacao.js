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
import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import AssignmentIcon from '@mui/icons-material/Assignment';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import api from '../../services/api';
import Estoquedetalhe from '../../components/formulario/suprimento/Estoquedetalhe';
import Notpermission from '../../layouts/notpermission/notpermission';
import Comprasedicao from '../../components/formulario/suprimento/Comprasedicao';
import exportExcel from '../../data/exportexcel/Excelexport';
import modoVisualizador from '../../services/modovisualizador';

export default function Solicitacao() {
  // CONSTANTES
  const [solicitacao, setsolicitacao] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [teladetalhe, setteladetalhe] = useState(false);
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [telacadastro, settelacadastro] = useState('');
  const [statussolicitacao, setstatussolicitacao] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');

  // Parâmetros
  const params = {
    busca: pesqgeral,
    status: statussolicitacao,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
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

  const listasolicitacao = async () => {
    try {
      setLoading(true);
      await api.get('v1/solicitacao/lista', { params }).then((response) => {
        setsolicitacao(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  }


  const atender = async (stat, qty, produto) => {
    try {
      await api
        .post('v1/solicitacao/requisicao', {
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
          idtipomovimentacao: 2,
          entrada: 0,
          saida: qty,
          balanco: 0,
          idsolicitacao: stat,
          idproduto: produto,
          evento: 'Atender',
        })
        .then((response) => {
          if (response.status === 201) {
            setmensagemsucesso('');
            listasolicitacao();
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
    } finally {
      console.log('');
    }
  };

  function detalhesproduto(stat) {
    setteladetalhe(true);
    setididentificador(stat);
    settitulo('Controle de Estoque - Lançamento');
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.solicitacao === 1);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<AssignmentIcon />}
          label="Detalhes"
          title="Detalhes"
          onClick={() => detalhesproduto(parametros.row.idproduto)}
        />,
        <GridActionsCellItem
          icon={<AssignmentTurnedInIcon />}
          label="Atender Solicitação"
          title="Atender Solicitação"
          onClick={() =>
            atender(parametros.id, parametros.row.quantidade, parametros.row.idproduto)
          }
        />,
      ],
    },
    // { field: 'id', headerName: 'Cod', width: 80, align: 'center' },
    { field: 'idsolicitacao', headerName: 'Solicitação', width: 90, align: 'center' },
    {
      field: 'data',
      headerName: 'Data',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
      valueFormatter: (parametros) => {
        const date = parseISO(parametros.value);
        return format(date, 'dd/MM/yyyy', { locale: ptBR });
      },
    },
    {
      field: 'status',
      headerName: 'Status',
      type: 'string',
      width: 130,
      align: 'left',
      editable: false,
    },
    {
      field: 'nome',
      headerName: 'Solicitante',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'projeto',
      headerName: 'Projeto',
      type: 'string',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'obra',
      headerName: 'Obra/OS',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Descrição',
      type: 'string',
      width: 250,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'unidade',
      headerName: 'Unidade',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
    },
    {
      field: 'quantidade',
      headerName: 'Quant. Solicitada',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'estoque',
      headerName: 'Quant. Estoque',
      type: 'string',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      type: 'string',
      width: 400,
      align: 'left',
      editable: false,
      renderCell: (parametros) => (
        <div
          style={{
            whiteSpace: 'pre-wrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical',
          }}
        >
          {parametros.value}
        </div>
      ),
    },
  ];

  const lancaritens = async (idcompra, idprod, idcompraitem, qntd) => {
    await api
      .post('v1/ordemcompra/itenssolicitacao', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idordemcompra: idcompra,
        idordemcompraitens: idcompraitem,
        idproduto: idprod,
        qtd: qntd,
        preco: 0,
        ipi: 0,
        valorst: 0,
        valortotal: 0,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
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

  const novocadastroitens = (idcompra, idprod) => {
    api
      .post('v1/ordemcompra/novocadastroitens', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          lancaritens(idcompra, idprod, response.data.retorno);
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

  const svlista = async (idcompra) => {
    try {
      await Promise.all(rowSelectionModel.map((id) => novocadastroitens(idcompra, id)));
    } catch (err) {
      setmensagem(err.message);
    } finally {
      settelacadastro(true); // Atualiza o estado para mostrar a tela
    }
  };

  const novocadastro = async () => {
    try {
      await api
        .post('v1/ordemcompra/novocadastro', {
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
        })
        .then((response) => {
          if (response.status === 201) {
            setididentificador(response.data.retorno);
            svlista(response.data.retorno);
            settitulo('Cadastrar Ordem de Compra');
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
    } finally {
      console.log('');
    }
  };

  function limparfiltro() {
    listasolicitacao();
  }

  const gerarexcel = () => {
    const excelData = solicitacao.map((item) => {
      return {
        Solicitação: item.idsolicitacao,
        Data: format(parseISO(item.data), 'dd/MM/yyyy', { locale: ptBR }),
        Status: item.status,
        Solicitante: item.nome,
        Projeto: item.projeto,
        'Obra/OS': item.obra,
        Descrição: item.descricao,
        Unidade: item.unidade,
        'Quant. Solicitada': item.quantidade,
        'Quant. Estoque': item.estoque,
        Observação: item.observacao,
      };
    });
    exportExcel({ excelData, fileName: 'solicitacao' });
  };

  const gerarexcelRelatorioCustoCompleto = async () => {
    const selectedRow = solicitacao.find(
      (item) => String(item.id) === String(rowSelectionModel[0]),
    );
    const obra = String(selectedRow?.obra ?? '').trim();

    await api
      .post('v1/controleestoque/relatorioCustoSolicitacao', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        obra,
      })
      .then((response) => {
        const totalData = response.data;
        const excelData = totalData.map((item) => {
          const bruto =
            Number(item?.valor_total ?? item?.valorTotal ?? 0);
          const custoFormatado = bruto.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
          return {
            'Obra/OS': item.obra,
            Projeto: item.projeto,
            Entrada: item.entrada,
            Saída: item.saida,
            'Custo Total': custoFormatado,
          };
        });
        exportExcel({ excelData, fileName: 'relatorio_custo_completo' });
      });
  };
  useEffect(() => {
    setstatussolicitacao('AGUARDANDO');
    listasolicitacao();
    userpermission();

  }, []);

  return (
    <div>
      {/**filtro */}
      {permission && (
        <div>
          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Solicitação de Material
              </CardTitle>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              {telacadastro ? (
                <Comprasedicao
                  show={telacadastro}
                  setshow={settelacadastro}
                  ididentificador={ididentificador}
                  titulotopo={titulo}
                />
              ) : null}
              {mensagemsucesso.length > 0 ? (
                <div className="alert alert-success" role="alert">
                  Registro Salvo
                </div>
              ) : null}
              <div className="row g-3">
                <div className="col-sm-9">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por Produto"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <div className="col-sm-3">
                      <Input
                        type="select"
                        onChange={(e) => setstatussolicitacao(e.target.value)}
                        value={statussolicitacao}
                        className="comprimento-tamanho"
                      >
                        <option value="AGUARDANDO">AGUARDANDO</option>
                        <option value="EM PROCESSO">EM PROCESSO</option>
                        <option value="ATENDIDO">ATENDIDO</option>
                        <option value="TODOS">TODOS</option>
                      </Input>
                    </div>
                    <Button color="primary" onClick={() => listasolicitacao()}>
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>
                <div className="col-sm-3 d-flex flex-row-reverse">
                  <Button
                    color="primary"
                    onClick={() => novocadastro()}
                    disabled={modoVisualizador()}
                  >
                    Gerar Pedido de Compra <Icon.Plus />
                  </Button>
                </div>
              </div>
            </CardBody>

            {/**tabela*/}
            <CardBody style={{ backgroundColor: 'white' }}>
              {/* BOTÃO PARA EXPORTAR EXCEL */}
              <Button color="link" onClick={() => gerarexcel()}>
                Exportar Excel
              </Button>
              <Button color="link" onClick={() => gerarexcelRelatorioCustoCompleto()}>
                Exportar Excel Relatório Custo Completo
              </Button>
              <Box
                sx={{
                  height: 600,
                  width: '100%',
                  overflowX: 'auto',
                }}
              >
                <DataGrid
                  rows={solicitacao}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  checkboxSelection
                  onRowSelectionModelChange={(newRowSelectionModel) => {
                    setRowSelectionModel(newRowSelectionModel);
                  }}
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
          {teladetalhe && (
            <Estoquedetalhe
              show={teladetalhe}
              setshow={setteladetalhe}
              ididentificador={ididentificador}
              atualiza={listasolicitacao}
              titulotopo={titulo}
            />
          )}
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
