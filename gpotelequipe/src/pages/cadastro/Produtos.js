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
import { Card, CardBody, CardTitle, InputGroup, Input, Button } from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { /*red, purple, green, amber, purple,*/ blue } from '@mui/material/colors';
import Battery6BarIcon from '@mui/icons-material/Battery6Bar';
import Battery1BarIcon from '@mui/icons-material/Battery1Bar';
import DoneAllIcon from '@mui/icons-material/DoneAll';
//import ShoppingCartCheckoutIcon from '@mui/icons-material/ShoppingCartCheckout';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import Produtosedicao from '../../components/formulario/cadastro/Produtosedicao';
import Excluirregistro from '../../components/Excluirregistro';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../services/modovisualizador';

export default function Produtos() {
  const [produtos, setprodutos] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [telacadastro, settelacadastro] = useState(false);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [titulo, settitulo] = useState('');
  const [habil, sethabil] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    aviso: 'PRODUTO',
    busca: pesqgeral,
    habilitado: habil,
  };

  const novocadastro = () => {
    api
      .post('v1/produto/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          settitulo('Cadastro de Produto');
          setididentificador(response.data.retorno);
          settelacadastro(true);
        } else {
          setmensagem(`Erro ao criar cadastro de produto. Status: ${response.status}`);
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(`Erro ao criar cadastro de produto: ${err.response.data.erro}`);
        } else if (err.request) {
          setmensagem('Não foi possível conectar-se ao servidor.');
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
      });
  };

  const listaprodutos = async () => {
    try {
      setLoading(true);
      await api.get('v1/produto', { params }).then((response) => {
        setprodutos(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.produtos === 1);
  }
  function alterarUser(stat) {
    setididentificador(stat);
    settitulo('Alteração de Produto');
    settelacadastroedicao(true);
  }

  function limparfiltro() {
    listaprodutos();
  }

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);
    const itens = produtos.length;

    return (
      <>
        {itens < 10 ? (
          <>
            <Box sx={{ width: '88%' }}>{itens !== 0 ? `Total de Produtos: ${itens}` : null}</Box>
          </>
        ) : (
          <>
            {itens < 21 && itens > 10 ? (
              <>
                <Box sx={{ width: '85%' }}>
                  {itens !== 0 ? `Total de Produtos: ${itens}` : null}
                </Box>
              </>
            ) : (
              <>
                {itens < 31 && itens > 20 ? (
                  <>
                    <Box sx={{ width: '82%' }}>
                      {itens !== 0 ? `Total de Produtos: ${itens}` : null}
                    </Box>
                  </>
                ) : (
                  <>
                    {itens < 40 && itens > 30 ? (
                      <>
                        <Box sx={{ width: '79%' }}>
                          {itens !== 0 ? `Total de Produtos: ${itens}` : null}
                        </Box>
                      </>
                    ) : (
                      <>
                        <Box sx={{ width: '70%' }}>
                          {itens !== 0 ? `Total de Produtos: ${itens}` : null}
                        </Box>
                      </>
                    )}
                  </>
                )}
              </>
            )}
          </>
        )}

        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value) => apiRef.current.setPage(value - 1)}
        />
      </>
    );
  }
  const gerarexcel = () => {
    const excelData = produtos.map((item) => {
      console.log(item);
      return {
        Codigo: item.id,
        Produto: item.descricao,
        Unidade: item.unidade,
        Categoria: item.categoria,
        Estoque: item.estoque,
        Habilitado: item.habilitado === 0 ? 'Desativado' : 'Ativado',
        'Estoque máximo': item.estoquemaximo === 0 ? 'Desativado' : 'Ativado',
        'Estoque minimo': item.estoqueminimo === 0 ? 'Desativado' : 'Ativado',
      };
    });
    exportExcel({ excelData, fileName: 'produtos' });
  };
  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 100,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          disabled={modoVisualizador()}
          onClick={() => deleteUser(parametros.id)}
        />,
        /*
        <GridActionsCellItem
          icon={<ShoppingCartCheckoutIcon />}
          label="Opções"
          onClick={() => toggleAdmin(parametros.id)}
          showInMenu
        />,
        */
      ],
    },
    { field: 'id', headerName: 'Codigo', width: 100, align: 'center' },
    {
      field: 'descricao',
      headerName: 'Produto',
      width: 500,
      align: 'left',
      type: 'string',
      editable: false,
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
      field: 'categoria',
      headerName: 'Categoria',
      type: 'string',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'estoque',
      headerName: 'Estoque',
      type: 'number',
      width: 100,
      align: 'center',
      editable: false,
    },
    {
      field: 'actions1',
      headerName: 'Marcadores',
      type: 'actions',
      width: 150,
      align: 'center',
      getActions: (opcoes) => [
        <GridActionsCellItem
          icon={<DoneAllIcon style={{ fill: blue[550 * opcoes.row.habilitado + 50] }} />} //2 check
          title="Habilitado Total"
        />,
        <GridActionsCellItem
          icon={<Battery6BarIcon style={{ fill: blue[550 * opcoes.row.estoquemaximo + 50] }} />} //bateria alta
          title="Estoque Máximo"
        />,
        <GridActionsCellItem
          icon={<Battery1BarIcon style={{ fill: blue[550 * opcoes.row.estoqueminimo + 50] }} />} //bateria baixa
          title="Estoque Mínimo"
        />,
      ],
    },
  ];
  useEffect(() => {
    userpermission();
  }, []);
  return (
    <div>
      {/**filtro */}
      {permission && (
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Listagem de Produtos
            </CardTitle>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            {mensagem.length !== 0 ? (
              <div className="alert alert-danger mt-2" role="alert">
                {mensagem}
              </div>
            ) : null}

            <div className="row g-3">
              <div className="col-sm-7">
                <InputGroup>
                  <Input
                    type="text"
                    placeholder="Pesquise por ID, Código ou Produto"
                    onChange={(e) => setpesqgeral(e.target.value)}
                    value={pesqgeral}
                  ></Input>

                  <div className="col-sm-4">
                    <Input
                      type="select"
                      onChange={(e) => sethabil(e.target.value)}
                      value={habil}
                      name=""
                      className="comprimento-tamanho"
                    >
                      <option value="0">Habilitado</option>
                      <option value="1">Desabilitado Total</option>
                      <option value="2">Desabilitado Parcial</option>
                      <option value="3">Todos</option>
                    </Input>
                  </div>

                  <Button color="primary" onClick={() => listaprodutos()}>
                    {' '}
                    <SearchIcon />
                  </Button>
                  <Button color="primary" onClick={() => limparfiltro()}>
                    {' '}
                    <AutorenewIcon />
                  </Button>
                </InputGroup>
              </div>

              <div className=" col-sm-5 d-flex flex-row-reverse">
                <Button
                  color="primary"
                  onClick={() => novocadastro()}
                  disabled={modoVisualizador()}
                >
                  Adicionar <Icon.Plus />
                </Button>

                {telacadastro && (
                  <>
                    {' '}
                    <Produtosedicao
                      show={telacadastro}
                      setshow={settelacadastro}
                      ididentificador={ididentificador}
                      atualiza={listaprodutos}
                      titulotopo={titulo}
                    />{' '}
                  </>
                )}
                {telacadastroedicao && (
                  <>
                    {' '}
                    <Produtosedicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={ididentificador}
                      atualiza={listaprodutos}
                      titulotopo={titulo}
                    />{' '}
                  </>
                )}
                {telaexclusao && (
                  <>
                    <Excluirregistro
                      show={telaexclusao}
                      setshow={settelaexclusao}
                      ididentificador={ididentificador}
                      quemchamou="PRODUTOS"
                      atualiza={listaprodutos}
                      idlojaatual={localStorage.getItem('sessionloja')}
                    />{' '}
                  </>
                )}
              </div>
            </div>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
            <Box
              sx={{
                height: produtos.length > 0 ? '100%' : 500,
                width: '100%',
                textAlign: 'right',
              }}
            >
              <DataGrid
                rows={produtos}
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
          </CardBody>
        </Card>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
