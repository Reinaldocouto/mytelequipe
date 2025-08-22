import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  GridActionsCellItem,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
  ptBR,
} from '@mui/x-data-grid';
import EditIcon from '@mui/icons-material/Edit';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rolloutericssonedicao from '../../components/formulario/rollout/Rolloutericssonedicao';
import Excluirregistro from '../../components/Excluirregistro';

const Rolloutericsson = ({ setshow, show }) => {
  const [pageSize, setPageSize] = useState(10);
  const [loading, setLoading] = useState(false);
  const [rollout, setrollout] = useState([]);
  const [mensagem, setmensagem] = useState('');
  const [ididentificador, setididentificador] = useState(0);
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [telaexclusao, settelaexclusao] = useState('');
  const [titulo, settitulo] = useState('');
  const [show1, setshow1] = useState(false);



  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };



  const listarolloutericsson = async () => {
    try {
      setLoading(true);
      const response = await api.get('v1/projetoericsson', { params });
      setrollout(response.data);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setLoading(false);
    }
  };



  function alterarUser(stat) {
    settitulo('Editar Rollout Ericsson');
    settelacadastroedicao(true);
    setididentificador(stat);
  }

  const [
    ErirssonSelecionado, setericssonSelecionado
  ] = useState(null);


  const columns = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<EditIcon />}
          label="Alterar"
          name="Alterar"
          hint="Alterar"
          onClick={() => {
            alterarUser(
              parametros.id,
            );
            setericssonSelecionado(parametros.row);
          }
          }
        />,
      ],
    },

    { field: 'rfp', headerName: 'RFP', width: 120 },
    { field: 'id', headerName: 'Número', width: 100 },
    { field: 'cliente', headerName: 'Cliente', width: 150 },
    { field: 'regiona', headerName: 'Regional', width: 150 },
    { field: 'site', headerName: 'Site', width: 150 },
    { field: 'fornecedor', headerName: 'Fornecedor', width: 150 },
    { field: 'situacaoimplantacao', headerName: 'Situação Impl.', width: 300, renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>, },
    { field: 'situacaodaintegracao', headerName: 'Situação Int.', width: 200, renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>, },
    {
      field: 'datadacriacaodademandadia',
      headerName: 'Data Criação Demanda',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datalimiteaceitedia',
      headerName: 'Data Limite Aceite',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'dataaceitedemandadia',
      headerName: 'Data Aceite Demanda',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datainicioprevistasolicitantebaselinemosdia',
      headerName: 'Início Prev. Solicitante',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datainicioentregamosplanejadodia',
      headerName: 'Início Entrega Planejada',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datarecebimentodositemosreportadodia',
      headerName: 'Recebimento Reportado',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datafimprevistabaselinefiminstalacaodia',
      headerName: 'Fim Prev. Baseline Inst.',
      width: 180,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datafiminstalacaoplanejadodia',
      headerName: 'Fim Inst. Planejada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'dataconclusaoreportadodia',
      headerName: 'Conclusão Reportada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datavalidacaoinstalacaodia',
      headerName: 'Validação Instalação',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'dataintegracaobaselinedia',
      headerName: 'Integração Baseline',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'dataintegracaoplanejadodia',
      headerName: 'Integração Planejada',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'datavalidacaoeriboxedia',
      headerName: 'Validação Eriboxe',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    { field: 'listadepos', headerName: 'Lista de POS', width: 150 },
    { field: 'gestordeimplantacaonome', headerName: 'Gestor Impl.', width: 300 },
    { field: 'statusrsa', headerName: 'Status RSA', width: 300 },
    { field: 'rsarsa', headerName: 'RSA', width: 100 },
    { field: 'arqsvalidadapelocliente', headerName: 'Docs Validados', width: 140 },
    { field: 'statusaceitacao', headerName: 'Status Aceite', width: 140 },
    {
      field: 'datadefimdaaceitacaosydledia',
      headerName: 'Fim Aceite Sydle',
      width: 160,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    { field: 'ordemdevenda', headerName: 'Ordem de Venda', width: 200 },
    { field: 'coordenadoaspnome', headerName: 'Coordenador ASP', width: 300 },
    {
      field: 'rsavalidacaorsanrotrackerdatafimdia',
      headerName: 'Fim Validação RSA Tracker',
      width: 200,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'fimdeobraplandia',
      headerName: 'Fim Obra Plan.',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    {
      field: 'fimdeobrarealdia',
      headerName: 'Fim Obra Real',
      width: 140,
      type: 'date',
      valueGetter: ({ value }) => value ? new Date(value) : null,
      valueFormatter: ({ value }) => value
        ? new Intl.DateTimeFormat('pt-BR').format(value)
        : ''
    },
    { field: 'tipoatualizacaofam', headerName: 'Tipo Atualização FAM', width: 200 },
    { field: 'sinergia', headerName: 'Sinergia', width: 100 },
    { field: 'sinergia5g', headerName: 'Sinergia 5G', width: 100 },
    { field: 'escoponome', headerName: 'Escopo', width: 300, renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>, },
    { field: 'slapadraoescopodias', headerName: 'SLA Padrão (dias)', width: 140 },
    { field: 'tempoparalisacaoinstalacaodias', headerName: 'Tempo Paralisação (dias)', width: 180 },
    { field: 'localizacaositeendereco', headerName: 'Endereço Site', width: 300, renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>, },
    { field: 'localizacaositecidade', headerName: 'Cidade Site', width: 300, renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>, },
    { field: 'documentacaosituacao', headerName: 'Situação Doc.', width: 300 },
    { field: 'sitepossuirisco', headerName: 'Site Possui Risco', width: 150 },


  ];

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

  const toggle = () => {
    setshow(!show);
  };

  const toggle1 = () => {
    setshow1(!show1);
  };

  const iniciatabelas = () => {
    listarolloutericsson();
  };

  const chamarfiltro = () => {
    setshow1(true);
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  /* ---------- helpers -------------------------------------------------- */
  const dateFields = new Set([
    // já existentes
    'ENTRGA_REQUEST', 'ENTREGA_PLAN', 'ENTREGA_REAL',
    'FIM_INSTALACAO_PLAN', 'FIM_INSTALACAO_REAL',
    'INTEGRACAO_PLAN', 'INTEGRACAO_REAL',
    'DT_PLAN', 'DT_REAL', 'DELIVERY_PLAN',
    'REGIONAL_LIB_SITE_P', 'REGIONAL_LIB_SITE_R',
    'EQUIPAMENTO_ENTREGA_P', 'REGIONAL_CARIMBO',
    'ATIVACAO_REAL', 'DOCUMENTACAO', 'INITIAL_TUNNING_REAL', 'INITIAL_TUNNING_STATUS',
    'VISTORIA_PLAN', 'VISTORIA_REAL',
    'DOCUMENTACAO_VISTORIA_PLAN',
    'DOCUMENTACAO_VISTORIA_REAL', 'REQ'
  ]);

  const toBRDate = (v) => {
    if (!v) return v;
    // “datas nulas” → vazio
    if (/^(1899-12-(30|31)|0000-00-00)/.test(v)) return '';

    // "YYYY-MM-DD HH:MM:SS" ⇒ "YYYY-MM-DDTHH:MM:SS"
    const spaced = typeof v === 'string' && v.includes(' ')
      ? v.replace(' ', 'T')
      : v;

    const d = spaced instanceof Date ? spaced : new Date(spaced);
    if (!Number.isNaN(d.getTime()))
      return d.toLocaleDateString('pt-BR');              // 28/04/2025

    // dd/mm/aaaa ou dd-mm-aaaa
    const br = typeof v === 'string' &&
      v.match(/^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$/);
    if (br) {
      const [, dd, mm, yyyy] = br;
      const normal = `${dd.padStart(2, '0')}/${mm.padStart(2, '0')}/${yyyy}`;
      if (normal === '31/12/1899' || normal === '30/12/1899') return '';
      return normal;
    }
    return v;                                            // valor não reconhecido
  };

  const formatDatesBR = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, dateFields.has(k) ? toBRDate(v) : v])
    );

  const upperStrings = (row) =>
    Object.fromEntries(
      Object.entries(row).map(([k, v]) => [k, typeof v === 'string' ? v.toUpperCase() : v])
    );

  /* ---------- função principal ---------------------------------------- */
  const gerarexcel = () => {
    const excelData = rollout
      .map(item => ({
        RFP: item.rfp,
        NÚMERO: item.numero,
        CLIENTE: item.cliente,
        REGIONAL: item.regiona,
        SITE: item.site,
        FORNECEDOR: item.fornecedor,
        'SITUAÇÃO IMPL.': item.situacaoimplantacao,
        'SITUAÇÃO INT.': item.situacaodaintegracao,

        'DATA CRIAÇÃO DEMANDA': item.datadacriacaodademandadia,
        'DATA LIMITE ACEITE': item.datalimiteaceitedia,
        'DATA ACEITE DEMANDA': item.dataaceitedemandadia,
        'INÍCIO PREV. SOLICITANTE': item.datainicioprevistasolicitantebaselinemosdia,
        'INÍCIO ENTREGA PLANEJADA': item.datainicioentregamosplanejadodia,
        'RECEBIMENTO REPORTADO': item.datarecebimentodositemosreportadodia,
        'FIM PREV. BASELINE INST.': item.datafimprevistabaselinefiminstalacaodia,
        'FIM INST. PLANEJADA': item.datafiminstalacaoplanejadodia,
        'CONCLUSÃO REPORTADA': item.dataconclusaoreportadodia,
        'VALIDAÇÃO INSTALAÇÃO': item.datavalidacaoinstalacaodia,
        'INTEGRAÇÃO BASELINE': item.dataintegracaobaselinedia,
        'INTEGRAÇÃO PLANEJADA': item.dataintegracaoplanejadodia,
        'VALIDAÇÃO ERIBOXE': item.datavalidacaoeriboxedia,

        'LISTA DE POS': item.listadepos,
        'GESTOR IMPL.': item.gestordeimplantacaonome,
        'STATUS RSA': item.statusrsa,
        RSA: item.rsarsa,
        'DOCS VALIDADOS': item.arqsvalidadapelocliente,
        'STATUS ACEITE': item.statusaceitacao,
        'FIM ACEITE SYDLE': item.datadefimdaaceitacaosydledia,

        'ORDEM DE VENDA': item.ordemdevenda,
        'COORDENADOR ASP': item.coordenadoaspnome,
        'FIM VAL. RSA TRACKER': item.rsavalidacaorsanrotrackerdatafimdia,
        'FIM OBRA PLAN.': item.fimdeobraplandia,
        'FIM OBRA REAL': item.fimdeobrarealdia,

        'TIPO ATUALIZAÇÃO FAM': item.tipoatualizacaofam,
        SINERGIA: item.sinergia,
        'SINERGIA 5G': item.sinergia5g,
        ESCOPO: item.escoponome,
        'SLA PADRÃO (DIAS)': item.slapadraoescopodias,
        'TEMPO PARALISAÇÃO (DIAS)': item.tempoparalisacaoinstalacaodias,

        'ENDEREÇO SITE': item.localizacaositeendereco,
        'CIDADE SITE': item.localizacaositecidade,
        'SIT. DOC.': item.documentacaosituacao,
        'SITE POSSUI RISCO': item.sitepossuirisco,
      }))
      .map(formatDatesBR)   // converte datas / zera 1899-12-xx
      .map(upperStrings);   // caixa-alta

    exportExcel({ excelData, fileName: 'ROLLOUT ERICSSON' });
  };





  return (
    <>
      <Modal
        isOpen={show1}
        toggle={toggle1}
        className="modal-dialog modal-lg modal-dialog-scrollable"
        backdrop="static"
        keyboard={false}
      >
        <ModalHeader toggle={toggle}>Filtro</ModalHeader>
        <ModalBody>
          <div>
            <div className="col-9 d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PMO - REF</span>
              <select
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO - REF"
                defaultValue=""
              >
                <option value="" disabled>
                  Selecione PMO-REF
                </option>
                <option value="Rollout_2025">Rollout_2025</option>
                <option value="Rollout_2026">Rollout_2026</option>
              </select>
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PMO - CATEGORIA</span>
              <select
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO - CATEGORIA"
                defaultValue=""
              >
                <option value="" disabled>
                  Selecione PMO-CATEGORIA
                </option>
                <option value="Existente">Existente</option>
                <option value="Novo">Novo</option>
              </select>
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">UID - IDPMTS</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite o UID - IDPMTS"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro UID - IDPMTS"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">UF/SIGLA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite o UF/SIGLA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro UF/SIGLA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PMO - SIGLA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - SIGLA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO - SIGLA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPmoref" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PMO - UF</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - UF"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO - UF"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkPmoregional"
                style={{ width: '20px', height: '20px' }}
              />

              <span className="mb-0">PMO - REGIONAL</span>

              <input
                type="text"
                className="form-control"
                placeholder="Digite o PMO - REGIONAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO - REGIONAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkCidade" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">CIDADE</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite a CIDADE"
                style={{ width: '400px', height: '40px', alignItems: 'center' }}
                aria-label="Filtro CIDADE"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkEAPAutomatica"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">EAP - AUTOMATICA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite EAP - AUTOMATICA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro EAP - AUTOMATICA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRegionalEAPInfra"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">REGIONAL - EAP - INFRA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL - EAP - INFRA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro REGIONAL - EAP - INFRA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkStatusMensalTx"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">STATUS-MENSAL-TX</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite STATUS-MENSAL-TX"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro STATUS-MENSAL-TX"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkMASTEROBRStatusRollout"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">MASTEROBR-STATUS-ROLLOUT</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite MASTEROBR-STATUS-ROLLOUT"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro MASTEROBR-STATUS-ROLLOUT"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRegionalLibSiteP"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">REGIONAL-LIB-SITE-P</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-LIB-SITE-P"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro REGIONAL-LIB-SITE-P"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRegionalLibSiteR"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">REGIONAL-LIB-SITE-R</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-LIB-SITE-R"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro REGIONAL-LIB-SITE-R"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkEquipamentoEntregaP"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">EQUIPAMENTO-ENTREGA-P</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite EQUIPAMENTO-ENTREGA-P"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro EQUIPAMENTO-ENTREGA-P"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRegionalCarimbo"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">REGIONAL-CARIMBO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-CARIMBO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro REGIONAL-CARIMBO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkRSORsaSci" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">RSO-RSA-SCI</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-SCI"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro RSO-RSA-SCI"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRSORsaSciStatus"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">RSO-RSA-SCI-STATUS</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-SCI-STATUS"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro RSO-RSA-SCI-STATUS"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRegionalOfensorDetalhe"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">REGIONAL-OFENSOR-DETALHE</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite REGIONAL-OFENSOR-DETALHE"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro REGIONAL-OFENSOR-DETALHE"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkVendorVistoria"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">VENDOR-VISTORIA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-VISTORIA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro VENDOR-VISTORIA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkVendorProjeto"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">VENDOR-PROJETO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-PROJETO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro VENDOR-PROJETO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkVendorInstalador"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">VENDOR-INSTALADOR</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-INSTALADOR"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro VENDOR-INSTALADOR"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkVendorIntegrador"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">VENDOR-INTEGRADOR</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite VENDOR-INTEGRADOR"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro VENDOR-INTEGRADOR"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkPMOTecnEquip"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">PMO-TECN-EQUIP</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite PMO-TECN-EQUIP"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO-TECN-EQUIP"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkPMOFreqEquip"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">PMO-FREQ-EQUIP</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite PMO-FREQ-EQUIP"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PMO-FREQ-EQUIP"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkUIDIDCPOMRF"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">UID-IDCPOMRF</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite UID-IDCPOMRF"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro UID-IDCPOMRF"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkStatusObra" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">STATUS OBRA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite STATUS OBRA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro STATUS OBRA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="date" id="chkDocPlan" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">DOC PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DOC PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DOC PLAN"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkEntregaRequest"
                style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">ENTREGA-REQUEST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-REQUEST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ENTREGA-REQUEST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkEntregaPlan"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">ENTREGA-PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ENTREGA-PLAN"
              />
            </div>
            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkvistoriareal"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">VISTORIA-REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite VISTORIA-REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro VISTORIA-REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkEntregaReal"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">ENTREGA-REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ENTREGA-REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ENTREGA-REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkFimInstalacaoReal"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">FIM INSTALAÇÃO REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite FIM INSTALAÇÃO REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro FIM INSTALAÇÃO REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkIntegracaoReal"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">INTEGRAÇÃO REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite INTEGRAÇÃO REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro INTEGRAÇÃO REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkAtivacao" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">ATIVAÇÃO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ATIVAÇÃO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ATIVAÇÃO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkDocumentacao"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">DOCUMENTAÇÃO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DOCUMENTAÇÃO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DOCUMENTAÇÃO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkInitialTunningReal" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">INITIAL TUNNING REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite INITIAL TUNNING REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro INITIAL TUNNING REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkDtReal" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">DT REAL</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DT REAL"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DT REAL"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkFimInstalacaoPlan"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">FIM INSTALAÇÃO PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite FIM INSTALAÇÃO PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro FIM INSTALAÇÃO PLAN"
              />
            </div>



            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkIntegracaoPlan"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">INTEGRAÇÃO PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite INTEGRAÇÃO PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro INTEGRAÇÃO PLAN"
              />
            </div>



            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkInitialTunningStatus" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">INITIAL TUNNING STATUS</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite INITIAL TUNNING STATUS"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro INITIAL TUNNING STATUS"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkDtPlan" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">DT PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DT PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DT PLAN"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkRollout" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">ROLLOUT</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ROLLOUT"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ROLLOUT"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkAcionamento"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">ACIONAMENTO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ACIONAMENTO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ACIONAMENTO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkNomeDoSite" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">NOME DO SITE</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite NOME DO SITE"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro NOME DO SITE"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkEndereco" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">ENDEREÇO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ENDEREÇO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ENDEREÇO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRSORSADetentora"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">RSO-RSA-DETENTORA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-DETENTORA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro RSO-RSA-DETENTORA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkRSORSAIDDentetora"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">RSO-RSA-ID-DENTETORA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite RSO-RSA-ID-DENTETORA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro RSO-RSA-DETENTORA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkResumoDaFase"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">RESUMO DA FASE</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite RESUMO DA FASE"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro RESUMO DA FASE"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkInfraVivo" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">INFRA VIVO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite INFRA VIVO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro INFRA VIVO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkEquipe" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">EQUIPE</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite EQUIPE"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro EQUIPE"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkDocaPlan" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">DOCA PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DOCA PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DOCA PLAN"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkDeliveryPlan"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">DELIVERY PLAN</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite DELIVERY PLAN"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro DELIVERY PLAN"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkOV" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">OV</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite OV"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro OV"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkAcesso" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">ACESSO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite ACESSO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro ACESSO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkT2Instalacao"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">T2 INSTALAÇÃO</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite T2 INSTALAÇÃO"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro T2 INSTALAÇÃO"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkNumeroDaReq"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">NÚMERO DA REQ - INST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO DA REQ - INST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro NÚMERO DA REQ - INST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkNumeroT2" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">NÚMERO T2 - INST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO T2 - INST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro NÚMERO T2 - INST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPedido" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PEDIDO - INST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite PEDIDO - INST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PEDIDO - INST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkT2Vistoria" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">T2 VISTORIA</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite T2 VISTORIA"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro T2 VISTORIA"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkNumeroDaReqVist"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">NÚMERO DA REQ - VIST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO DA REQ - VIST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro NÚMERO DA REQ - VIST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input
                type="checkbox"
                id="chkNumeroT2Vist"
                style={{ width: '20px', height: '20px' }}
              />
              <span className="mb-0">NÚMERO T2 - VIST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite NÚMERO T2 - VIST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro NÚMERO T2 - VIST"
              />
            </div>

            <div className="d-flex align-items-center gap-3 mb-3">
              <input type="checkbox" id="chkPedidoVist" style={{ width: '20px', height: '20px' }} />
              <span className="mb-0">PEDIDO - VIST</span>
              <input
                type="text"
                className="form-control"
                placeholder="Digite PEDIDO - VIST"
                style={{ width: '400px', height: '40px' }}
                aria-label="Filtro PEDIDO - VIST"
              />
            </div>
          </div>
        </ModalBody>
        <ModalFooter>
          <Button color="primary" onClick={toggle1}>
            Aplicar Filtro
          </Button>{' '}
          <Button color="secondary" onClick={toggle1}>
            Cancel
          </Button>
        </ModalFooter>
      </Modal>

      <Modal
        isOpen={show}
        toggle={toggle}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable"
      >
        <ModalHeader>Rollout - Ericsson</ModalHeader>
        <ModalBody>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              {telacadastroedicao ? (
                <>
                  {' '}
                  <Rolloutericssonedicao
                    show={telacadastroedicao}
                    setshow={settelacadastroedicao}
                    ididentificador={ididentificador}
                    atualiza={listarolloutericsson}
                    ericssonSelecionado={ErirssonSelecionado}
                    //pmuf={pmuf}
                    titulotopo={titulo}
                  //idpmtslocal={idpmtslocal}
                  />{' '}
                </>
              ) : null}

              {telaexclusao ? (
                <>
                  <Excluirregistro
                    show={telaexclusao}
                    setshow={settelaexclusao}
                    ididentificador={ididentificador}
                    quemchamou="ROLLOUTERICSSON"
                    atualiza={listarolloutericsson}
                  />{' '}
                </>
              ) : null}

              <div className="row g-3">
                <div className="col-sm-3">
                  <Button color="link" onClick={gerarexcel}>
                    Exportar Excel
                  </Button>
                </div>
                <div className="col-sm-9">
                  <div className=" col-sm-12 d-flex flex-row-reverse">
                    <Button color="primary" onClick={chamarfiltro}>
                      Aplicar Filtros
                    </Button>
                  </div>
                </div>
              </div>
              <br />
              <Box sx={{ height: '85%', width: '100%' }}>
                <DataGrid
                  rows={rollout}
                  columns={columns}
                  loading={loading}
                  pageSize={pageSize}
                  onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                  disableSelectionOnClick
                  components={{
                    Pagination: CustomPagination,
                    LoadingOverlay: LinearProgress,
                    NoRowsOverlay: CustomNoRowsOverlay,
                  }}
                  localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                />
              </Box>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Rolloutericsson.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Rolloutericsson;
