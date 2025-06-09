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
import Fornecedoredicao from '../../components/formulario/cadastro/Fornecedoredicao';
import modoVisualizador from '../../services/modovisualizador';

export default function Fornecedor() {
  const [fornecedor, setfornecedor] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [titulo, settitulo] = useState('');
  const [ididentificador, setididentificador] = useState(0);

  const params = {
    busca: pesqgeral,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const listafornecedor = async () => {
    try {
      setLoading(true);
      await api.get('v1/fornecedor', { params }).then((response) => {
        setfornecedor(response.data);
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
    listafornecedor();
  }

  function alterarUser(stat) {
    settitulo('Editar Fornecedor');
    settelacadastroedicao(true);
    setididentificador(stat);
    listafornecedor();
  }

  function limparfiltro() {
    listafornecedor();
  }

  const novocadastro = () => {
    api
      .post('v1/fornecedor/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
          settitulo('Cadastro de Fornecedor');
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
      width: 120,
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
    /*
        { field: 'id', headerName: 'ID', width: 60, align: 'center', },
         */
    {
      field: 'nome',
      headerName: 'Fornecedor',
      width: 400,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'celular',
      headerName: 'Celular',
      type: 'string',
      width: 220,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'cidade',
      headerName: 'Cidade',
      type: 'string',
      width: 220,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'uf',
      headerName: 'Estado',
      type: 'string',
      width: 80,
      align: 'rigth',
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
    listafornecedor();
  }, []);
  return (
    <div>
      {/**filtro */}
      <Card style={{ backgroundColor: 'white' }}>
        <CardBody className="bg-light" style={{ backgroundColor: 'white' }}>
          <CardTitle tag="h4" className="mb-0">
            Fornecedor
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
                <Button color="primary" onClick={() => listafornecedor()}>
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
              <Button color="primary" onClick={() => novocadastro()}>
                Adicionar <Icon.Plus />
              </Button>
              {telacadastro ? (
                <>
                  {' '}
                  <Fornecedoredicao
                    show={telacadastro}
                    setshow={settelacadastro}
                    ididentificador={ididentificador}
                    atualiza={listafornecedor}
                    titulotopo={titulo}
                  />{' '}
                </>
              ) : null}
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Fornecedoredicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={listafornecedor}
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
                    quemchamou="FORNECEDOR"
                    atualiza={listafornecedor}
                    idlojaatual={localStorage.getItem('sessionloja')}
                  />{' '}
                </>
              ) : null}
            </div>
          </div>
        </CardBody>
        {/**tabela*/}
        <CardBody>
          <Box sx={{ height: 650, width: '100%' }}>
            <DataGrid
              rows={fornecedor}
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
    </div>
  );
}
