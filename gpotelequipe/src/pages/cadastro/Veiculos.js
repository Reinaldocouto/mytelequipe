import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  GridActionsCellItem,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
} from '@mui/x-data-grid';
import { Row, Col, Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import CheckIcon from '@mui/icons-material/Check';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import SearchIcon from '@mui/icons-material/Search';
import Despesasedicao from '../../components/formulario/cadastro/Despesasedicao';
import api from '../../services/api';
import Excluirregistro from '../../components/Excluirregistro';
import Veiculosedicao from '../../components/formulario/cadastro/Veiculosedicao';
import exportExcel from '../../data/exportexcel/Excelexport';
import Notpermission from '../../layouts/notpermission/notpermission';
import modoVisualizador from '../../services/modovisualizador';
import IndicadorCnh from '../../components/dashboard/Dashboards/IndicadorCnh';
import IndicadorInspecao from '../../components/dashboard/Dashboards/IndicadorInspecao';
import VeiculosInspecaoPeriodica from '../../components/dashboard/veiculos/VeiculosInspecaoPeriodica';

export default function Veiculos() {
  const [veiculos, setveiculos] = useState([]);
  // const [filteredVeiculos, setFilteredVeiculos] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [titulo, settitulo] = useState('');
  const [statusveiculo, setstatusveiculo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [ididentificadordespesas, setididentificadordespesas] = useState(0);
  const [permission, setpermission] = useState(0);
  const [showGraphs, setShowGraphs] = useState(false);
  const [telalancamentodespesas, setTelalancamentodespesas] = useState(false);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    statusveic: statusveiculo,
    deletado: 0,
  };

  const listaveiculos = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/veiculos', { params });
      setveiculos(response.data);
      //  setFilteredVeiculos(response.data);
      setpesqgeral('');
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  /* const filterVeiculos = () => {
     const filtered = veiculos.filter((veiculo) => {
       const nomeMatch = veiculo.nome && veiculo.nome.toLowerCase().includes(pesqgeral.toLowerCase());
       const placaMatch = veiculo.placa && veiculo.placa.toLowerCase().includes(pesqgeral.toLowerCase());
       return nomeMatch || placaMatch;
     });
     setFilteredVeiculos(filtered);
   };*/

  function deleteUser(stat) {
    setididentificador(stat);
    //console.log("id do veiculo: ", stat);
    settelaexclusao(true);
    listaveiculos();
  }

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.veiculos === 1);
  }

  function alterarUser(stat) {
    settitulo('Editar Veiuclos');
    settelacadastroedicao(true);
    setididentificador(stat);
    listaveiculos();
  }

  function limparfiltro() {
    // setFilteredVeiculos(veiculos);
    listaveiculos();
  }

  const novocadastro = () => {
    api
      .post('v1/veiculos/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastro de Veículos');
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

  const gerarexcel = () => {
    const excelData = veiculos.map((item) => {
      return {
        Condutor: item.nome,
        Inspecaoveicular: item.inspecaoveicular,
        Modelo: item.modelo,
        Placa: item.placa,
        Cor: item.cor,
        Categoria: item.categoria,
        Marca: item.marca,
        Fabricação: item.fabricacao,
        Doc: item.doc,
        Status: item.status,
      };
    });
    exportExcel({ excelData, fileName: 'veiculos' });
  };

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
          hint="Alterar"
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          label="Delete"
          disabled={modoVisualizador()}
          onClick={() => deleteUser(parametros.id)}
        />,

        <GridActionsCellItem
          icon={<CheckIcon />}
          label="Lançar Despesas"
          disabled={modoVisualizador()}
          onClick={() => {
            api
              .post('v1/despesas/novocadastro', {
                idcliente: localStorage.getItem('sessionCodidcliente'),
                idusuario: localStorage.getItem('sessionId'),
                idloja: localStorage.getItem('sessionloja'),
              })
              .then((response) => {
                if (response.status === 201) {
                  setididentificadordespesas(response.data.retorno);
                  setTelalancamentodespesas(true);
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
          }}
          showInMenu
        />,
      ],
    },
    {
      field: 'nome',
      headerName: 'Condutor',
      type: 'string',
      width: 350,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'placa',
      headerName: 'Placa',
      type: 'string',
      width: 100,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'inspecaoveicular',
      headerName: 'Inspeção veicular',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'modelo',
      headerName: 'Modelo',
      width: 300,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cor',
      headerName: 'Cor',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'marca',
      headerName: 'Marca',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'fabricacao',
      headerName: 'Fabricação',
      type: 'string',
      width: 100,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'doc',
      headerName: 'Doc',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'status',
      headerName: 'Status',
      type: 'string',
      width: 80,
      align: 'left',
      editable: false,
    },
  ];

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

  useEffect(() => {
    listaveiculos();
    userpermission();
    setstatusveiculo('ATIVO');
  }, []);

  /*  useEffect(() => {
      filterVeiculos();
    }, [pesqgeral, veiculos]); */

  const modalLancamentoDeDespesas = () => {
    return telalancamentodespesas ? (
      <Despesasedicao
        show={telalancamentodespesas}
        setshow={setTelalancamentodespesas}
        atualiza={() => {}}
        titulotopo="Cadastro da despesa"
        ididentificador={ididentificadordespesas}
      />
    ) : null;
  };

  return (
    <div>
      {permission && (
        <div>
          {modalLancamentoDeDespesas()}
          <Card>
            <CardBody className="bg-light d-flex justify-content-between align-items-center">
              <CardTitle tag="h4" className="mb-0">
                Listagem de Veículos
              </CardTitle>
              <Button color="primary" onClick={() => setShowGraphs(!showGraphs)}>
                {showGraphs ? 'Ocultar Gráficos' : 'Mostrar Gráficos'} <Icon.BarChart2 size={16} />
              </Button>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {showGraphs && (
                <Row>
                  <Col lg="12">
                    <VeiculosInspecaoPeriodica />
                  </Col>
                  <Col lg="6">
                    <IndicadorInspecao />
                  </Col>
                  <Col lg="6">
                    <IndicadorCnh />
                  </Col>
                </Row>
              )}
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              <div className="row g-3">
                <div className="col-sm-3">
                  <Input
                    type="select"
                    onChange={(e) => setstatusveiculo(e.target.value)}
                    value={statusveiculo}
                  >
                    <option value="ATIVO">ATIVO</option>
                    <option value="INATIVO">INATIVO</option>
                    <option value="TODOS">TODOS</option>
                  </Input>
                </div>
                <div className="col-sm-6">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por Nome ou Placa"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Button color="primary" onClick={() => listaveiculos()}>
                      {' '}
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      {' '}
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>

                <div className=" col-sm-3  d-flex flex-row-reverse">
                  <Button
                    color="primary"
                    onClick={() => novocadastro()}
                    disabled={modoVisualizador()}
                  >
                    Adicionar <Icon.Plus />
                  </Button>
                  {telacadastro ? (
                    <>
                      {' '}
                      <Veiculosedicao
                        show={telacadastro}
                        setshow={settelacadastro}
                        ididentificador={ididentificador}
                        atualiza={listaveiculos}
                        titulotopo={titulo}
                      />{' '}
                    </>
                  ) : null}
                  {telacadastroedicao ? (
                    <>
                      {' '}
                      <Veiculosedicao
                        show={telacadastroedicao}
                        setshow={settelacadastroedicao}
                        ididentificador={ididentificador}
                        atualiza={listaveiculos}
                        titulotopo={titulo}
                      />{' '}
                    </>
                  ) : null}
                  {telaexclusao ? (
                    <>
                      <Excluirregistro
                        show={telaexclusao}
                        setshow={settelaexclusao}
                        ididentificador={ididentificador}
                        quemchamou="VEICULOS"
                        atualiza={listaveiculos}
                      />{' '}
                    </>
                  ) : null}
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
                  //    height: filteredVeiculos.length > 10 ? '100%' : 500,
                  height: veiculos.length > 10 ? '100%' : 500,
                  width: '100%',
                  textAlign: 'right',
                }}
              >
                <DataGrid
                  //rows={filteredVeiculos}
                  rows={veiculos}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress }}
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
