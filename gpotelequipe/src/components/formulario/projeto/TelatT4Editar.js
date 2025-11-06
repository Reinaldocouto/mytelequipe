import { useState, useEffect } from 'react';
import {
  FormGroup,
  Label,
  FormText,
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Input,
} from 'reactstrap';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
  GridActionsCellItem,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import DeleteIcon from '@mui/icons-material/Delete';
import { Box, Typography } from '@mui/material';
import { toast, ToastContainer } from 'react-toastify';
import PropTypes from 'prop-types';
import { gerarDocxT4, gerarPDFT4 } from '../../../services/docx';
import logotelequipe from '../../../assets/images/logos/logotelequipe.png?url';
import logotelefonica from '../../../assets/images/logos/logo_telefonica.png?url';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';
import Excluirregistro from '../../Excluirregistro';
import exportExcel from '../../../data/exportexcel/Excelexport';

const TelatT4Editar = ({ setshow, show, titulo, pmuf, idobra }) => {
  const [loading, setloading] = useState(false);
  const [search, setSearch] = useState();
  const [fileT2, setFileT2] = useState();
  const [nf, setNF] = useState();
  const [labelStatusFaturamento, setLabelStatusFaturamento] = useState('Gerada T2');
  const [labelStatusSite, setLabelStatusSite] = useState('');
  const [handleViewFatura, setHandleViewFatura] = useState(false);
  const [fileT4, setFileT4] = useState();
  if (1 === 0) {
    console.log(fileT2);
    console.log(fileT4);
    console.log(setshow, show, titulo, pmuf, idobra);
  }
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [telaexclusaot2, settelaexclusaot2] = useState(false);
  const [paginationModelatividade, setPaginationModelatividade] = useState({
    pageSize: 11,
    page: 0,
  });
  async function fetchImageAsBuffer(url) {
    const response = await fetch(url);
    const blob = await response.blob();
    const arrayBuffer = await blob.arrayBuffer();
    return new Uint8Array(arrayBuffer);
  }
  const [idt2, setidt2] = useState(0);
  const [atividades, setatividades] = useState([]);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    search,
    labelStatus: labelStatusFaturamento,
    labelStatusSite,
  };

  const toggle = () => {
    setshow(!show);
  };

  const sanitizeFileName = (name) => `${name}`.replace(/[\\/:*?"<>|]/g, '_');


  const handleFileUploadT2 = async (e) => {
    e.preventDefault();

    if (!fileT2) {
      toast.warning('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', fileT2);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploadt2', formData, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          toast.success('Importação concluido.');
        } else {
          toast.success('Erro ao fazer importação!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        toast.error(err.message);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setloading(false);
    }
  };
  const handleFileUploadT4 = async (e) => {
    e.preventDefault();

    if (!fileT4) {
      toast.warning('Nenhum arquivo selecionado para atualizar!');
      return;
    }

    const formData = new FormData();
    formData.append('files', fileT4);

    const header = {
      headers: {
        'Custom-Header': 'value',
      },
    };
    try {
      setloading(true);
      const response = await api.post('v1/uploadt4', formData, header);
      if (response && response.data) {
        if (response.status === 200) {
          toast.success('Importação concluido.');
        } else {
          toast.error('Erro ao fazer importação!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        toast.error(err.message);
      } else {
        toast.error('Erro: Tente novamente mais tarde!');
      }
    } finally {
      setloading(false);
    }
  };
  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);
    const rowCount = apiRef.current.getRowsCount(); // Obtém total de itens
    return (
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          padding: '10px',
        }}
      >
        <Typography variant="body2">Total de itens: {rowCount}</Typography>

        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  function deleteUser(stat) {
    setidt2(stat);
    settelaexclusaot2(true);
  }

  const colunasatividades = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'empresa',
      headerName: 'EMPRESA',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SITE',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'itemt2',
      headerName: 'ITEM T2',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'codfornecedor',
      headerName: 'COD FORNECEDOR',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'fabricante',
      headerName: 'FABRICANTE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'numerodocontrato',
      headerName: 'NUMERO DO CONTRATO',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'T2 - COD MAT SERV SW',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 't2descricaocod',
      headerName: 'T2 DESCRICAO COD',
      width: 400,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitarioliqliq',
      headerName: 'VLR UNITARIO LIQLIQ',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitarioliq',
      headerName: 'VLR UNITARIO LIQ',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'quant',
      headerName: 'QUANT',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'unid',
      headerName: 'UNID',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitariocimposto',
      headerName: 'VLR UNITARIO C/ IMPOSTO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrcimpsicms',
      headerName: 'VLR C/ IMP S ICMS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrtotalcimpostos',
      headerName: 'VLR TOTAL C/ IMPOSTOS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'itemt4',
      headerName: 'ITEM T4',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't4codeqmatswserv',
      headerName: 'T4 - COD EQ MAT SW SERV',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't4descricaocod',
      headerName: 'T4 - DESCRIÇÃO COD',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel2',
      headerName: 'PEP NÍVEL 2',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'idlocalidade',
      headerName: 'ID LOCALIDADE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel3',
      headerName: 'PEP NÍVEL 3',
      width: 250,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoobra',
      headerName: 'DESCRIÇÃO DA OBRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'idobra',
      headerName: 'ID OBRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'enlace',
      headerName: 'ENLACE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'gestor',
      headerName: 'GESTOR',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'responsavel',
      headerName: 'RESPONSAVAEL',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'categoria',
      headerName: 'CATEGORIA',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'tecnologia',
      headerName: 'TECNOLOGIA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'statusfaturamento',
      headerName: 'Status',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'po',
      headerName: 'PO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'notafiscal',
      headerName: 'Nota Fiscal',
      width: 150,
      align: 'left',
      editable: false,
    },
  ];
  const gerarCartaTAFDocx = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione um item para gerar a carta TAF');
      return;
    }
    if (rowSelectionModel.length > 1) {
      toast.warning('Selecione apenas um item para gerar a carta TAF');
      return;
    }
    const selected = atividades.find((item) => item.id === rowSelectionModel[0]);
    if (
      selected.statusfaturamento === 'Gerada T2' ||
      selected.statusfaturamento === 'Retorno T2' ||
      selected.statusfaturamento === 'Gerada T4'
    ) {
      toast.warning('Não é possivel gerar a carta taf para esse item, não esta na etapa correta');
      return;
    }

    const telequipeBuffer = await fetchImageAsBuffer(logotelequipe);
    const telefonicaBuffer = await fetchImageAsBuffer(logotelefonica);
    const selectedItensArray = [selected];
    gerarDocxT4(selectedItensArray, telequipeBuffer, telefonicaBuffer);
  };

  const gerarCartaTAFPDF = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione um item para gerar a carta TAF');
      return;
    }
    if (rowSelectionModel.length > 1) {
      toast.warning('Selecione apenas um item para gerar a carta TAF');
      return;
    }
    const selected = atividades.find((item) => item.id === rowSelectionModel[0]);
    if (
      selected.statusfaturamento === 'Gerada T2' ||
      selected.statusfaturamento === 'Retorno T2' ||
      selected.statusfaturamento === 'Gerada T4'
    ) {
      toast.warning('Não é possivel gerar a carta taf para esse item, não esta na etapa correta');
      return;
    }
    const selectedItensArray = [selected];

    gerarPDFT4(selectedItensArray);
  };

  const listatarefas = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/listat4', { params }).then((response) => {
        setatividades(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const iniciatabelas = () => {
    listatarefas();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  const gerarT4Excel = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione ao menos um item para gerar T4 XLSM');
      return;
    }

    const selecionados = rowSelectionModel
      .map((id) => atividades.find((i) => i.id === id))
      .filter(Boolean);
    const invalidos = selecionados.filter((s) => s.statusfaturamento === 'Gerada T2');
    const validos = selecionados.filter((s) => s.statusfaturamento !== 'Gerada T2');

    if (invalidos.length > 0) {
      toast.info(`${invalidos.length} item(ns) ignorado(s) por não estar(em) na etapa correta`);
    }

    if (validos.length === 0) {
      toast.warning('Nenhum item válido para gerar T4 XLSM');
      return;
    }

    try {
      setloading(true);

      await Promise.all(
        validos.map(async (selected) => {
          const response = await api.get('v1/gerart4excel', {
            responseType: 'blob',
            params: selected,
          });

          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', `${sanitizeFileName(selected.pepnivel3)}.xlsm`);
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          window.URL.revokeObjectURL(url);
        }),
      );

      toast.success(`Gerado(s) ${validos.length} arquivo(s) T4 XLSM`);
    } catch (err) {
      toast.error('Erro ao gerar T4 XLSM');
    } finally {
      setloading(false);
    }
  };

  const salvarNotaFiscal = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione um item para salvar a nota fiscal');
      return;
    }

    if (rowSelectionModel.length > 1) {
      toast.warning('Selecione apenas um item para salvar a nota fiscal');
      return;
    }

    const selected = atividades.find((item) => item.id === rowSelectionModel[0]);
    selected.notafiscal = nf;
    const response = await api.post('v1/projetotelefonica/salvarnotafiscal', {
      ...selected,
    });
    if (response.data.erro) {
      toast.error(response.erro);
      return;
    }

    if (response.data.sucesso) {
      toast.success('Atualizado com sucesso');
    }
  };
  const atualizarEmFaturamento = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione um item para atualizar');
      return;
    }

    if (rowSelectionModel.length > 1) {
      toast.warning('Selecione apenas um item para atualizar');
      return;
    }

    const selected = atividades.find((item) => item.id === rowSelectionModel[0]);
    if (selected.statusfaturamento !== 'Gerada Carta TAF') {
      toast.warning('Não é possivel atualizar para esse item, não esta na etapa correta');

      return;
    }

    const response = await api.post('v1/projetotelefonica/emfaturamento', {
      ...selected,
    });
    if (response.erro) {
      toast.error(response.data.erro);
      return;
    }

    if (response.data.sucesso) {
      toast.success('Atualizado com sucesso');
    }
  };

  const gerarT4CSV = async () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecione ao menos um item para gerar T4 CSV');
      return;
    }

    const selecionados = rowSelectionModel
      .map((id) => atividades.find((i) => i.id === id))
      .filter(Boolean);
    const invalidos = selecionados.filter((s) => s.statusfaturamento === 'Gerada T2');
    const validos = selecionados.filter((s) => s.statusfaturamento !== 'Gerada T2');

    if (invalidos.length > 0) {
      toast.info(`${invalidos.length} item(ns) ignorado(s) por não estar(em) na etapa correta`);
    }

    if (validos.length === 0) {
      toast.warning('Nenhum item válido para gerar T4 CSV');
      return;
    }

    try {
      setloading(true);

      await Promise.all(
        validos.map(async (selected) => {
          const response = await api.get('v1/gerart4csv', {
            responseType: 'blob',
            params: selected,
          });

          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', `${sanitizeFileName(selected.pepnivel3)}.csv`);
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          window.URL.revokeObjectURL(url);
        }),
      );

      toast.success(`Gerado(s) ${validos.length} arquivo(s) T4 CSV`);
    } catch (err) {
      toast.error('Erro ao gerar T4 CSV');
    } finally {
      setloading(false);
    }
  };

  const hasValue = (v) => v !== null && v !== undefined && String(v).trim() !== '';

  const hasT4 = (r) =>
    hasValue(r.itemt4) || hasValue(r.t4codeqmatswserv) || hasValue(r.t4descricaocod);

  const isSemT4PorRegra = (r) => {
    if (hasT4(r)) return false;

    const tipo = (r.tipo || '').toUpperCase();

    if (tipo === 'INSTALLATION') {
      const statusDoc =
        (r.rolloutStatusDocumentacao ||
          r.rollout_status_documentacao ||
          r.statusdoc ||
          '').toUpperCase();
      return statusDoc === 'APROVADO';
    }

    if (tipo === 'DRIVE TEST') {
      const dtExec =
        r.rolloutDtReal || r.rollout_data_execucao || r.dtReal || r.dt_real;
      return hasValue(dtExec);
    }

    if (tipo === 'SURVEY') {
      const dtVist =
        r.rolloutDataVistoria || r.rollout_data_vistoria || r.dataVistoria;
      return hasValue(dtVist);
    }

    return false;
  };


  const handleFaturado = () => {
    if (rowSelectionModel.length === 0) {
      toast.warning('Selecioen um item');
      return;
    }
    if (rowSelectionModel.length > 1) {
      toast.warning('Selecioen apenas um item');
      return;
    }

    const selected = atividades.find((item) => item.id === rowSelectionModel[0]);
    if (selected.statusfaturamento !== 'Em Faturamento') {
      toast.warning('Não é possivel para esse item, não esta na etapa correta');
      return;
    }
    setHandleViewFatura(!handleViewFatura);
  };
  const gerarexcel = () => {
    const excelData = atividades.map((item) => ({
      EMPRESA: item.empresa,
      SITE: item.site,
      'ITEM T2': item.itemt2,
      'CÓD. FORNECEDOR': item.codfornecedor,
      FABRICANTE: 'TELEQUIPE',
      'NUMERO DO CONTRATO': item.numerodocontrato,
      'T2 - COD MAT_SERV_SW': item.t2codmatservsw,
      'T2 - DESCRIÇÃO COD': item.t2descricaocod,
      'VLR_UNITÁRIO LIQLIQ': item.vlrunitarioliqliq === 0 ? '' : item.vlrunitarioliqliq,
      'VLR UNITÁRIO LIQ': item.vlrunitarioliq,
      QUANT: item.quant,
      UNID: item.unid,
      'VLR UNITÁRIO C/ IMPOSTO': item.vlrunitariocimposto,
      'VLR C_IMP S_ICMS': item.vlrcimpsicms,
      'VLR TOTAL C_IMPOSTOS': item.vlrtotalcimpostos,
      'ITEM T4': item.itemt4,
      'T4 - COD EQ_ MAT_SW_SERV': item.t4codeqmatswserv,
      'T4 - DESCRIÇÃO COD': item.t4descricaocod,
      'PEP NÍVEL 2': item.pepnivel2,
      'ID LOCALIDADE': item.idlocalidade,
      'PEP NÍVEL 3': item.pepnivel3,
      'ID OBRA': item.idobra,
      'DATA DE ENTREGA': '',
      ENLACE: item.enlace,
      GESTOR: item.gestor,
      'TIPO (Hardware; Software; Serviço; Material)': item.tipo,
      Responsável: item.responsavel,
      CATEGORIA: item.categoria,
      TECNOLOGIA: item.tecnologia,
      'STATUS FATURAMENTO': item.statusfaturamento,
      'Status Site': item.statussite,
    }));
    exportExcel({ excelData, fileName: 't2' });
  };

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
      >
        <ModalHeader toggle={toggle.bind(null)}>{titulo}</ModalHeader>
        <ModalBody>
          {telaexclusaot2 ? (
            <>
              <Excluirregistro
                show={telaexclusaot2}
                setshow={settelaexclusaot2}
                ididentificador={idt2}
                quemchamou="CRIACAOT2"
                atualiza={listatarefas}
              />{' '}
            </>
          ) : null}

          <ToastContainer
            style={{ zIndex: 9999999 }}
            position="top-right"
            autoClose={2000}
            hideProgressBar={false}
            newestOnTop
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />

          <div className="container-fluid">
            <div className="row g-3">
              {/* Upload de arquivos T2 e T4 */}
              <div className="col-md-6">
                <FormGroup>
                  <Label for="exampleFileT2">Importar T2</Label>
                  <div className="d-flex gap-2">
                    <Input
                      id="exampleFileT2"
                      name="fileT2"
                      type="file"
                      onChange={(e) => setFileT2(e.target.files[0])}
                    />
                    <Button color="primary" onClick={handleFileUploadT2}>
                      Upload
                    </Button>
                  </div>
                  <FormText className="mt-1">
                    Selecione um arquivo para importar os dados T2.
                  </FormText>
                </FormGroup>
              </div>

              <div className="col-md-6">
                <FormGroup>
                  <Label for="exampleFileT4">Importar T4</Label>
                  <div className="d-flex gap-2">
                    <Input
                      id="exampleFileT4"
                      name="fileT4"
                      type="file"
                      onChange={(e) => setFileT4(e.target.files[0])}
                    />
                    <Button color="primary" onClick={handleFileUploadT4}>
                      Upload
                    </Button>
                  </div>
                  <FormText className="mt-1">
                    Selecione um arquivo para importar os dados T4.
                  </FormText>
                </FormGroup>
              </div>
              <hr></hr>

              {/* Filtro de pesquisa e status */}
              <div className="col-md-4  d-flex align-items-end">
                <Input
                  type="text"
                  placeholder="Pesquisar"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                />
              </div>

              <div className="col-md-4">
                <Input
                  type="select"
                  id="statusSelect"
                  value={labelStatusFaturamento}
                  onChange={(e) => setLabelStatusFaturamento(e.target.value)}
                >
                  <option value="Gerada T2">Gerada T2</option>
                  <option value="Retorno T2">Retorno T2</option>
                  <option value="Gerada T4">Gerada T4</option>
                  <option value="Retorno T4">Retorno T4</option>
                  <option value="Gerada Carta TAF">Gerada Carta TAF</option>
                  <option value="Em Faturamento">Em Faturamento</option>
                  <option value="Faturado">Faturado</option>
                </Input>
              </div>
              <div className="col-md-4">
                <Input
                  type="select"
                  id="statusSelect"
                  value={labelStatusSite}
                  onChange={(e) => setLabelStatusSite(e.target.value)}
                >
                  <option value="">Selecione</option>
                  <option value="T4 criada">T4 criada</option>
                  <option value="Serviço acionado, mas ainda sem T4">
                    Serviço acionado, mas ainda sem T4
                  </option>
                  <option value="Serviço executado sem T4">Serviço executado sem T4</option>
                  <option value="T2 criada, mas ainda não acionada">
                    T2 criada, mas ainda não acionada.
                  </option>
                </Input>
              </div>

              <div className="col-md-12 d-flex align-items-end">
                <Button
                  color="primary"
                  onClick={listatarefas}
                  disabled={modoVisualizador()}
                  className="w-100"
                >
                  Buscar
                </Button>
              </div>

              <hr></hr>
              {/* Botões de exportação */}
              <div className="col-12 d-flex flex-wrap gap-2 mt-3">
                <Button color="primary" onClick={gerarexcel} disabled={modoVisualizador()}>
                  Gerar Excel
                </Button>
                <Button color="primary" onClick={gerarT4CSV} disabled={modoVisualizador()}>
                  Gerar T4 CSV
                </Button>
                <Button color="primary" onClick={gerarT4Excel} disabled={modoVisualizador()}>
                  Gerar T4 XLSM
                </Button>
                <Button color="secondary" onClick={gerarCartaTAFDocx}>
                  Exportar Carta TAF DOCX
                </Button>
                <Button color="secondary" onClick={gerarCartaTAFPDF}>
                  Exportar Carta TAF PDF
                </Button>
              </div>

              {/* Botões de status */}
              <div className="col-12 d-flex gap-2 mt-2">
                <Button
                  color="warning"
                  onClick={atualizarEmFaturamento}
                  disabled={modoVisualizador()}
                >
                  Marcar como Em Faturamento
                </Button>
                <Button color="success" onClick={handleFaturado} disabled={modoVisualizador()}>
                  Marcar como Faturado
                </Button>
              </div>

              {/* Campo para Nota Fiscal (condicional) */}
              {handleViewFatura && (
                <div className="col-md-6 d-flex gap-2 mt-4">
                  <Input
                    type="text"
                    placeholder="Nota Fiscal"
                    value={nf}
                    onChange={(e) => setNF(e.target.value)}
                  />
                  <Button color="primary" onClick={salvarNotaFiscal}>
                    Salvar
                  </Button>
                  <Button color="secondary" onClick={() => setHandleViewFatura(false)}>
                    Cancelar
                  </Button>
                </div>
              )}
            </div>
          </div>

          <Box
            sx={{
              height: atividades.length > 0 ? '300' : 300,
              width: '100%',
              '& .row-t4': {
                backgroundColor: '#a5d6a7', // Verde médio
                '&:hover': {
                  backgroundColor: '#81c784', // Verde mais escuro no hover
                },
              },
              '& .row-acionado': {
                backgroundColor: '#ffcc80',
                '&:hover': {
                  backgroundColor: '#ffb74d',
                },
              },
              // AZUL para T2 não acionada
              '& .row-t2': {
                backgroundColor: '#90caf9',
                '&:hover': {
                  backgroundColor: '#64b5f6',
                },
              },
              // VERMELHO para serviço executado sem T4
              '& .row-sem-t4': {
                backgroundColor: '#ef9a9a',
                '&:hover': {
                  backgroundColor: '#e57373',
                },
              },
            }}
          >
            <DataGrid
              rows={atividades}
              columns={colunasatividades}
              loading={loading}
              checkboxSelection
              disableSelectionOnClick
              experimentalFeatures={{ newEditingApi: true }}
              paginationModel={paginationModelatividade}
              onPaginationModelChange={setPaginationModelatividade}
              rowSelectionModel={rowSelectionModel}
              onRowSelectionModelChange={setRowSelectionModel}
              processRowUpdate={(newRow) => {
                setatividades((prev) =>
                  prev.map((row) => (row.rowId === newRow.rowId ? newRow : row)),
                );
                return newRow;
              }}
              getRowClassName={({ row }) => {
                if (isSemT4PorRegra(row)) return 'row-sem-t4';
                switch (row.statussite) {
                  case 'T4 criada':
                    return 'row-t4';
                  case 'Serviço acionado, mas ainda sem T4':
                    return 'row-acionado';
                  case 'T2 criada, mas ainda não acionada':
                    return 'row-t2';
                  case 'Serviço executado sem T4':
                    return 'row-sem-t4';
                  default:
                    return '';
                }
              }}

              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
            />

            <div className="mt-3">
              <Typography variant="subtitle1" className="mb-2">
                Legenda de cores:
              </Typography>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '12px' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <div style={{ width: 20, height: 20, backgroundColor: '#a5d6a7', borderRadius: 4 }}></div>
                  <span>T4 criada</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <div style={{ width: 20, height: 20, backgroundColor: '#ffcc80', borderRadius: 4 }}></div>
                  <span>Serviço acionado, mas ainda sem T4</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <div style={{ width: 20, height: 20, backgroundColor: '#90caf9', borderRadius: 4 }}></div>
                  <span>T2 criada, mas ainda não acionada</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <div style={{ width: 20, height: 20, backgroundColor: '#ef9a9a', borderRadius: 4 }}></div>
                  <span>Serviço executado sem T4</span>
                </div>
              </div>
            </div>

          </Box>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

TelatT4Editar.propTypes = {
  setshow: PropTypes.func.isRequired,
  show: PropTypes.bool.isRequired,
  titulo: PropTypes.bool.isRequired,
  pmuf: PropTypes.bool.isRequired,
  idobra: PropTypes.string.isRequired,
};

export default TelatT4Editar;
