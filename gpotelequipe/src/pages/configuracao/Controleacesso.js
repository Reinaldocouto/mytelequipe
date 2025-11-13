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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import SearchIcon from '@mui/icons-material/Search';
import Excluirregistro from '../../components/Excluirregistro';
import api from '../../services/api';
import Controleacessoedicao from '../../components/formulario/configuracao/Controleacessoedicao';
import modoVisualizador from '../../services/modovisualizador';

export default function Controleacesso() {
  const [controleacesso, setcontroleacesso] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [telacadastro, settelacadastro] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [ididentificador, setididentificador] = useState(0);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idclientebusca: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    deletado: 0,
  };

  const listacontroleacesso = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/cadusuariosistema', { params });

      // Filtrando a resposta no frontend com base na pesquisa por nome ou e-mail
      const dadosFiltrados = response.data.filter(
        (usuario) =>
          usuario.nome.toLowerCase().includes(pesqgeral.toLowerCase()) ||
          usuario.email.toLowerCase().includes(pesqgeral.toLowerCase()),
      );

      setcontroleacesso(dadosFiltrados);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    listacontroleacesso();
  }, [pesqgeral]);

  const novocadastro = () => {
    api
      .post('v1/cadusuariosistema/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setididentificador(response.data.retorno);
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

  function deleteUser(stat) {
    settelaexclusao(true);
    setididentificador(stat);
    listacontroleacesso();
  }

  function alterarUser(stat) {
    console.log(stat);
    settelacadastroedicao(true);
    setididentificador(stat);
    listacontroleacesso();
  }

  function limparfiltro() {
    setpesqgeral('');
    listacontroleacesso();
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
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },

    {
      field: 'nome',
      headerName: 'Nome',
      width: 500,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'email',
      headerName: 'Email',
      width: 350,
      align: 'rigth',
      editable: false,
    },
    {
      field: 'ativo',
      headerName: 'Ativo',
      width: 120,
      type: 'boolean',
      align: 'center',
      editable: false,
    },
  ];

  useEffect(() => {
    listacontroleacesso();
  }, []);

  return (
    <div>
      {/**filtro */}
      <Card style={{ backgroundColor: 'white' }}>
        <CardBody className="bg-light">
          <CardTitle tag="h4" className="mb-0">
            Cadastro de Usuários do Sistema
          </CardTitle>
        </CardBody>

        <CardBody>
          {mensagem.length !== 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}

          <div className="row g-3">
            <div className="col-sm-8">
              <InputGroup>
                <Input
                  type="text"
                  placeholder="Pesquise por Nome ou Email"
                  onChange={(e) => setpesqgeral(e.target.value)}
                  value={pesqgeral}
                ></Input>
                <Button color="primary" onClick={() => listacontroleacesso()}>
                  {' '}
                  <SearchIcon />
                </Button>
                <Button color="primary" onClick={() => limparfiltro()}>
                  {' '}
                  <AutorenewIcon />
                </Button>
              </InputGroup>
            </div>
            <div className=" col-sm-4 d-flex flex-row-reverse button-group">
              <Button color="primary" onClick={() => novocadastro()}>
                Adicionar <Icon.Plus />
              </Button>
            </div>
          </div>
          {telacadastro && (
            <Controleacessoedicao
              show={telacadastro}
              setshow={settelacadastro}
              ididentificador={ididentificador}
              atualiza={listacontroleacesso}
            />
          )}
          {telacadastroedicao && (
            <>
              {' '}
              <Controleacessoedicao
                show={telacadastroedicao}
                setshow={settelacadastroedicao}
                ididentificador={ididentificador}
                atualiza={listacontroleacesso}
              />{' '}
            </>
          )}
          {telaexclusao && (
            <>
              <Excluirregistro
                show={telaexclusao}
                setshow={settelaexclusao}
                ididentificador={ididentificador}
                quemchamou="CONFIGURACOESUSUARIO"
                atualiza={listacontroleacesso}
                idlojaatual={localStorage.getItem('sessionloja')}
              />{' '}
            </>
          )}
        </CardBody>

        {/**tabela*/}
        <CardBody>
          <Box sx={{ height: 650, width: '100%' }}>
            <DataGrid
              rows={controleacesso}
              columns={columns}
              loading={loading}
              pageSize={pageSize}
              onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
              disableSelectionOnClick
              experimentalFeatures={{ newEditingApi: true }}
              components={{ Pagination: CustomPagination, LoadingOverlay: LinearProgress }}
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
