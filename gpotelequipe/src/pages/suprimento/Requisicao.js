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
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import { format, parseISO } from 'date-fns';
import { ptBR } from 'date-fns/locale';
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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import CancelIcon from '@mui/icons-material/Cancel';
import api from '../../services/api';
import Notpermission from '../../layouts/notpermission/notpermission';
import exportExcel from '../../data/exportexcel/Excelexport';

export default function Solicitacao() {
  // CONSTANTES
  const [solicitacao, setsolicitacao] = useState([]);
  const [pesqgeral, setpesqgeral] = useState('');
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setLoading] = useState(false);
  const [pageSize, setPageSize] = useState(10);
  const [permission, setpermission] = useState(0);
  const [showApprovalModal, setShowApprovalModal] = useState(false);
  const [selectedRequest, setSelectedRequest] = useState(null);
  const [observation, setObservation] = useState('');

  // Parâmetros
  const params = {
    busca: pesqgeral,
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
      await api.get('v1/solicitacao/requisicao', { params }).then((response) => {
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

  const handleApproval = async () => {
    try {
      const response = await api.post('v1/solicitacao/requisicao/aprovacao', {
        idsolicitacao: selectedRequest.id,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        observacao: observation,
        data_aprovacao: new Date().toISOString(),
        ...selectedRequest,
      });

      if (response.status === 201) {
        setmensagemsucesso('Requisição aprovada com sucesso!');
        setShowApprovalModal(false);
        setObservation('');
        listasolicitacao();
      }
    } catch (err) {
      setmensagem(err.response?.data?.erro || 'Erro ao aprovar requisição');
    }
  };

  const openApprovalModal = (paramsopen) => {
    paramsopen.row = { ...paramsopen.row, ...params };
    paramsopen.row.aprovadopor = localStorage.getItem('sessionNome');
    setSelectedRequest(paramsopen.row);
    setShowApprovalModal(true);
  };

  const cancelaratendimento = async (stat, qty, produto) => {
    try {
      await api
        .post('v1/solicitacao/requisicao', {
          idcliente: localStorage.getItem('sessionCodidcliente'),
          idusuario: localStorage.getItem('sessionId'),
          idloja: localStorage.getItem('sessionloja'),
          idtipomovimentacao: 1,
          entrada: qty,
          saida: 0,
          balanco: 0,
          idsolicitacao: stat,
          idproduto: produto,
          evento: 'Cancelamento de Atendimento',
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
      getActions: (parametros) => {
        const actions = [];

        if (parametros.row.statusaprovacao !== 'APROVADO') {
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
            icon={<CancelIcon />}
            label="Cancelar Atendimento"
            title="Cancelar Atendimento"
            onClick={() =>
              cancelaratendimento(
                parametros.id,
                parametros.row.quantidade,
                parametros.row.idproduto,
              )
            }
          />,
        );

        return actions;
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
      field: 'nome',
      headerName: 'Solicitante',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'dataatendimento',
      headerName: 'Atendido em',
      type: 'string',
      width: 120,
      align: 'left',
      editable: false,
      valueFormatter: (parametros) => {
        const dateate = parseISO(parametros.value);
        return format(dateate, 'dd/MM/yyyy', { locale: ptBR });
      },
    },
    {
      field: 'nomeatendente',
      headerName: 'Atendido por',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'nomeaprovador',
      headerName: 'Aprovado por',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },

    {
      field: 'statusaprovacao',
      headerName: 'Status da Aprovação',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'dataaprovada',
      headerName: 'Data Aprovada',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
    },
    {
      field: 'observacao',
      headerName: 'Observação',
      type: 'string',
      width: 200,
      align: 'left',
      editable: false,
      renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
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
  ];

  function limparfiltro() {
    listasolicitacao();
  }

  const gerarexcel = () => {
    const excelData = solicitacao.map((item) => {
      return {
        Solicitação: item.idsolicitacao,
        Data: format(parseISO(item.data), 'dd/MM/yyyy', { locale: ptBR }),
        Solicitante: item.nome,
        'Atendido em': item.dataatendimento
          ? format(parseISO(item.dataatendimento), 'dd/MM/yyyy', { locale: ptBR })
          : '',
        'Atendido por': item.nomeatendente,
        Projeto: item.projeto,
        'Obra/OS': item.obra,
        Descrição: item.descricao,
        Unidade: item.unidade,
        'Quant. Solicitada': item.quantidade,
      };
    });
    exportExcel({ excelData, fileName: 'solicitacao' });
  };

  useEffect(() => {
    userpermission();
  }, []);
  return (
    <div>
      {permission && (
        <div>
          <div>
            <Modal
              isOpen={showApprovalModal}
              toggle={() => setShowApprovalModal(false)}
              className="modal-dialog modal-dialog-centered"
            >
              <ModalHeader toggle={() => setShowApprovalModal(false)}>
                Aprovar Requisição
              </ModalHeader>
              <ModalBody>
                <Form>
                  <FormGroup>
                    <Label>Aprovado por:</Label>
                    <Input type="text" value={selectedRequest?.aprovadopor || ''} disabled />
                  </FormGroup>
                  <FormGroup>
                    <Label>Solicitante</Label>
                    <Input type="text" value={selectedRequest?.nome || ''} disabled />
                  </FormGroup>
                  <FormGroup>
                    <Label>Projeto</Label>
                    <Input type="text" value={selectedRequest?.projeto || ''} disabled />
                  </FormGroup>
                  <FormGroup>
                    <Label>Descrição do Produto</Label>
                    <Input type="text" value={selectedRequest?.descricao || ''} disabled />
                  </FormGroup>
                  <FormGroup>
                    <Label>Observação</Label>
                    <Input
                      type="textarea"
                      value={observation}
                      onChange={(e) => setObservation(e.target.value)}
                      rows="4"
                    />
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
          </div>
          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Requisição de Material
              </CardTitle>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
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
                      placeholder="Pesquise por Código ou Produto"
                      onChange={(e) => setpesqgeral(e.target.value)}
                      value={pesqgeral}
                    ></Input>
                    <Button color="primary" onClick={() => listasolicitacao()}>
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>
              </div>
            </CardBody>

            {/* BOTÃO PARA EXPORTAR EXCEL */}
            <CardBody style={{ backgroundColor: 'white' }}>
              <Button color="link" onClick={() => gerarexcel()}>
                Exportar Excel
              </Button>
              <Box
                sx={{
                  height: solicitacao.length > 6 ? '100%' : 500,
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
        </div>
      )}
      {!permission && <Notpermission />}
    </div>
  );
}
