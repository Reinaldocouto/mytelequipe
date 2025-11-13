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
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Card, CardBody, CardTitle, Button, Input, InputGroup } from 'reactstrap';
import * as Icon from 'react-feather';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import Notpermission from '../../layouts/notpermission/notpermission';
import Excluirregistro from '../../components/Excluirregistro';
import Solicitacaoedicao from '../../components/formulario/suprimento/Solicitacaoedicao';
import exportExcel from '../../data/exportexcel/Excelexport';
import modoVisualizador from '../../services/modovisualizador';

export default function Solicitacao() {
  // CONSTANTES
  const [solicitacao, setsolicitacao] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [titulo, settitulo] = useState('');
  const [telacadastrosolicitacao, settelacadastrosolicitacao] = useState(false);
  const [permission, setpermission] = useState(0);
  const [statussolicitacao, setstatussolicitacao] = useState('');
  const [identificadorsolicitacao, setidentificadorsolicitacao] = useState('');
  const [telaexclusaosolicitacao, settelaexclusaosolicitacao] = useState('');
  const [telacadastroedicaosolicitacao, settelacadastroedicaosolicitacao] = useState('');

  // Parâmetros
  const params = {
    busca: pesqgeral,
    status: statussolicitacao,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
    projeto: 'Avulso',
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
        console.log('solicitação lista: ', response.data);
        setsolicitacao(response.data);
        setpesqgeral('');
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.solicitacaoavulsa === 1);
  }
  function deletedespesa(stat) {
    settelaexclusaosolicitacao(true);
    setidentificadorsolicitacao(stat);
  }
  function alterardespesa(stat) {
    settelacadastroedicaosolicitacao(true);
    setidentificadorsolicitacao(stat);
  }

  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => {
        console.log(parametros.row);
        if (parametros.row.status === 'AGUARDANDO') {
          return [
            <GridActionsCellItem
              icon={<EditIcon />}
              label="Alterar"
              title="Alterar"
              onClick={() => alterardespesa(parametros.row.idsolicitacao)}
            />,
            <GridActionsCellItem
              icon={<DeleteIcon />}
              disabled={modoVisualizador()}
              label="Delete"
              title="Delete"
              onClick={() => deletedespesa(parametros.row.idsolicitacao)}
            />,
          ];
        }
        return [];
      },
    },
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
      width: 400,
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
      width: 250,
      align: 'left',
      renderCell: (parametros) => (
        <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>
      ),
    },
  ];

  const novocadastro = () => {
    api
      .post('v1/solicitacao/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidentificadorsolicitacao(response.data.retorno);
          console.log(response.data.retorno);
          settitulo('Cadastrar Solicitação de Produto');
          settelacadastrosolicitacao(true);
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
    listasolicitacao();
  }

  useEffect(() => {
    listasolicitacao();
    userpermission();
  }, []);

  const handleSolicitarMaterial = () => {
    setmensagem('');
    novocadastro();
  };

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
        'Observação': item.observacao,
      };
    });
    exportExcel({ excelData, fileName: 'solicitacao-avulso' });
  };

  return (
    <div>
      {permission && (
        <div>
          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Solicitação de Material Avulso
              </CardTitle>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              <div className="row g-3">
                <div className="col-sm-9">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por Código ou Produto"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Input
                      type="select"
                      name=""
                      onChange={(e) => setstatussolicitacao(e.target.value)}
                      value={statussolicitacao}
                      className="comprimento-tamanho"
                    >
                      <option value="">TODOS</option>
                      <option value="AGUARDANDO">AGUARDANDO</option>
                      <option value="EM PROCESSO">EM PROCESSO</option>
                      <option value="ATENDIDO">ATENDIDO</option>
                    </Input>
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
                    onClick={() => handleSolicitarMaterial()}
                    disabled={modoVisualizador()}
                  >
                    Solicitar Material/Serviço <Icon.Plus />
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
              <Box
                sx={{
                  height: 500,
                  width: '100%',
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
                  experimentalFeatures={{ newEditingApi: true }}
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={{
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
          {telacadastrosolicitacao ? (
            <Solicitacaoedicao
              show={telacadastrosolicitacao}
              setshow={settelacadastrosolicitacao}
              ididentificador={identificadorsolicitacao}
              atualiza={listasolicitacao}
              titulotopo={titulo}
              novo="1"
              projetousual="Avulso"
              numero={null}
            />
          ) : null}
          {telacadastroedicaosolicitacao ? (
            <Solicitacaoedicao
              show={telacadastroedicaosolicitacao}
              setshow={settelacadastroedicaosolicitacao}
              ididentificador={identificadorsolicitacao}
              atualiza={listasolicitacao}
              titulotopo="Editar solicitação de material"
              novo="0"
              projetousual="Avulso"
              numero={null}
            />
          ) : null}
          {telaexclusaosolicitacao ? (
            <Excluirregistro
              show={telaexclusaosolicitacao}
              setshow={settelaexclusaosolicitacao}
              ididentificador={identificadorsolicitacao}
              quemchamou="SOLICITACAO"
              atualiza={listasolicitacao}
              idlojaatual={localStorage.getItem('sessionloja')}
            />
          ) : null}
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
