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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import Excluirregistro from '../../components/Excluirregistro';
import Multasedicao from '../../components/formulario/cadastro/Multasedicao';
import Notpermission from '../../layouts/notpermission/notpermission';
import exportExcel from '../../data/exportexcel/Excelexport';
import modoVisualizador from '../../services/modovisualizador';

export default function Multas() {
  const [multas, setmultas] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [permission, setpermission] = useState(0);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }
  const listamultas = async () => {
    try {
      setLoading(true);
      const response = await api.get('/v1/multas', { params });
      setmultas(response.data);
      setpesqgeral('');
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function deleteUser(stat) {
    setididentificador(stat);
    settelaexclusao(true);
    listamultas();
  }
  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.gestaomultas === 1);
  }

  function alterarUser(stat) {
    settitulo('Editar Multas');
    settelacadastroedicao(true);
    setididentificador(stat);
    listamultas();
  }

  function limparfiltro() {
    listamultas();
  }

  const novocadastro = () => {
    api
      .post('v1/multas/novocadastro', {
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
    const excelData = multas.map((item) => {
      return {
        'Nome Indicado': item.funcionario,
        Placa: item.placa,
        'Numero AIT': item.numeroait,
        'Data/Hora Infracao': item.datainfracao,
        'Local Infração': item.local,
        Infracao: item.infracao,
        Valor: item.valor,
        'Data Limite Indicacao': item.dataindicacao,
        Natureza: item.natureza,
        Pontuação: item.pontuacao,
        'Data Envio Colaborador': item.datacolaborador,
        Multa: item.statusmulta,
      };
    });
    exportExcel({ excelData, fileName: 'multas' });
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
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'funcionario',
      headerName: 'Nome Indicado',
      type: 'string',
      width: 250,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'placa',
      headerName: 'Placa',
      width: 100,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'numeroait',
      headerName: 'Número AIT',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'datainfracao',
      headerName: 'Data/Hora Infração',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'local',
      headerName: 'Local Infração',
      type: 'string',
      width: 400,
      align: 'rigth',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'infracao',
      headerName: 'Infração',
      type: 'string',
      width: 400,
      align: 'rigth',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'valor',
      headerName: 'Valor',
      type: 'string',
      width: 100,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'dataindicacao',
      headerName: 'Data Limite Indicação ',
      type: 'string',
      width: 180,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'natureza',
      headerName: 'Natureza',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'pontuacao',
      headerName: 'Pontuação',
      type: 'string',
      width: 150,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'datacolaborador',
      headerName: 'Data Envio Colaborador',
      type: 'string',
      width: 170,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'statusmulta',
      headerName: 'Status',
      type: 'string',
      width: 300,
      align: 'rigth',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
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
    userpermission();
    const fetchMultas = async () => {
      await listamultas();
    };

    fetchMultas();
  }, []);
  return (
    <div>
      {permission && (
        <Card>
          <CardBody className="bg-light">
            <CardTitle tag="h4" className="mb-0">
              Listagem de Multas
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
                    placeholder="Pesquise por Nome"
                    onChange={(e) => setpesqgeral(e.target.value)}
                    value={pesqgeral}
                  ></Input>
                  <Button color="primary" onClick={() => listamultas()}>
                    {' '}
                    <SearchIcon />
                  </Button>
                  <Button color="primary" onClick={() => limparfiltro()}>
                    {' '}
                    <AutorenewIcon />
                  </Button>
                </InputGroup>
              </div>

              <div className=" col-sm-6  d-flex flex-row-reverse">
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
                    <Multasedicao
                      show={telacadastro}
                      setshow={settelacadastro}
                      ididentificador={ididentificador}
                      atualiza={listamultas}
                      titulotopo={titulo}
                    />{' '}
                  </>
                ) : null}
                {telacadastroedicao ? (
                  <>
                    {' '}
                    <Multasedicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={ididentificador}
                      atualiza={listamultas}
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
                      quemchamou="MULTAS"
                      atualiza={listamultas}
                    />{' '}
                  </>
                ) : null}
              </div>
            </div>
            <br></br>
          </CardBody>
          <CardBody style={{ backgroundColor: 'white' }}>
            <Button color="link" onClick={() => gerarexcel()}>
              {' '}
              Exportar Excel
            </Button>
            <Box sx={{ height: multas.length > 0 ? '450px' : 500, width: '100%' }}>
              {' '}
              <DataGrid
                rows={multas}
                columns={columns}
                loading={loading}
                pageSize={pageSize}
                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                disableSelectionOnClick
                experimentalFeatures={{ newEditingApi: true }}
                components={{
                  NoRowsOverlay: CustomNoRowsOverlay,
                  Pagination: CustomPagination,
                  LoadingOverlay: LinearProgress,
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
