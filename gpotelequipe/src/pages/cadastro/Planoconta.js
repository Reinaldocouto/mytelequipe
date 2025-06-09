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
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import FileCopyIcon from '@mui/icons-material/FileCopy';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SecurityIcon from '@mui/icons-material/Security';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import SearchIcon from '@mui/icons-material/Search';
import api from '../../services/api';
import Excluirregistro from '../../components/Excluirregistro';
import Planocontaedicao from '../../components/formulario/cadastro/Planocontaedicao';
import modoVisualizador from '../../services/modovisualizador';

export default function Marca() {
  function toggleAdmin() {}

  function duplicateUser() {}

  const [planoconta, setplanoconta] = useState([]);
  const [loading, setLoading] = useState(false);
  const [mensagem, setmensagem] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [pageSize, setPageSize] = useState(10);
  const [pesqgeral, setpesqgeral] = useState('');
  const [titulo, settitulo] = useState('');

  //Parametros
  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listaplanoconta = async () => {
    try {
      setLoading(true);
      await api.get('/v1/planoconta', { params }).then((response) => {
        setplanoconta(response.data);
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
    settelaexclusao(true);
    setididentificador(stat);
    listaplanoconta();
  }

  function alterarUser(stat) {
    settelacadastroedicao(true);
    setididentificador(stat);
    listaplanoconta();
  }

  function limparfiltro() {
    listaplanoconta();
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

  const novocadastro = () => {
    api
      .post('v1/planoconta/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastrar Plano de Conta');
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
          onClick={() => alterarUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
        <GridActionsCellItem
          icon={<SecurityIcon />}
          label="Toggle Admin"
          onClick={() => toggleAdmin(parametros.id)}
          showInMenu
        />,
        <GridActionsCellItem
          icon={<FileCopyIcon />}
          label="Duplicate User"
          onClick={() => duplicateUser(parametros.id)}
          showInMenu
        />,
      ],
    },
    { field: 'id', headerName: 'ID', width: 80, align: 'center' },
    {
      field: 'codigo',
      headerName: 'Código',
      width: 150,
      align: 'center',
      editable: false,
    },
    {
      field: 'descricao',
      headerName: 'Plano de Conta',
      width: 450,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'Tipo',
      width: 150,
      align: 'rigth',
      editable: false,
    },
  ];

  const iniciatabelas = () => {
    listaplanoconta();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <div>
      {/**filtro */}
      <Card>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Listagem Plano de Conta
          </CardTitle>
        </CardBody>
        <CardBody>
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
                  placeholder="Pesquise por Plano de Conta"
                  onChange={(e) => setpesqgeral(e.target.value)}
                  value={pesqgeral}
                ></Input>
                <Button color="primary" onClick={() => listaplanoconta()}>
                  {' '}
                  <SearchIcon />
                </Button>
                <Button color="primary" onClick={() => limparfiltro()}>
                  {' '}
                  <AutorenewIcon />
                </Button>
              </InputGroup>
            </div>
            <div className="col-sm-6 d-flex flex-row-reverse">
              <Button color="primary" onClick={() => novocadastro()}>
                Adicionar <Icon.Plus />
              </Button>
              {telacadastro ? (
                <Planocontaedicao
                  show={telacadastro}
                  setshow={settelacadastro}
                  ididentificador={ididentificador}
                  atualiza={() => listaplanoconta()}
                  titulotopo={titulo}
                />
              ) : null}
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Planocontaedicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={listaplanoconta}
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
                    quemchamou="PLANOCONTA"
                    atualiza={listaplanoconta}
                  />{' '}
                </>
              ) : null}
            </div>
          </div>
        </CardBody>

        <CardBody>
          <Box sx={{ height: 650, width: '100%' }}>
            <DataGrid
              rows={planoconta}
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
  );
}
