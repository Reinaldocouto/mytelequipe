import { useState, useEffect, useCallback, useMemo } from 'react';
import {
  Col,
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import Select from 'react-select';
import Typography from '@mui/material/Typography';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';
import DEPARTAMENTOS_TELE_EQUIPE from './constants/departamentosTeleEquipe';
import naturezaPontuacaoText from './constants/naturezaPontuacaoText';
import infracaoDataText from './constants/infracaoDataText';

const asStr = (v) => (v ?? '');
const asUpper = (v) => (v ? String(v).toUpperCase() : '');
const asNumOrEmpty = (v) => (v === null || v === undefined ? '' : v);

const infracaoDataLines = infracaoDataText.trim().split('\n');
const naturezaPontuacaoLines = naturezaPontuacaoText.trim().split('\n');

function parseNaturezaPontuacao(line) {
  line = line.trim();
  if (line === '---' || line === '') {
    return { pontuacao: '', natureza: '' };
  }
  line = line.replace(/–/g, '-');
  const regex = /^(\d+)\s*-?\s*(.+)$/;
  const match = line.match(regex);
  if (match) {
    const pontuacao = match[1].trim();
    const natureza = match[2].trim();
    return { pontuacao, natureza };
  }
  return { pontuacao: '', natureza: line };
}

const infracaoOptions = infracaoDataLines.map((line, index) => {
  const parts = line.split('\t');
  const code = parts[0].trim();
  const desdobramento = parts.length > 2 ? parts[1].trim() : '';
  const description =
    parts.length > 2 ? parts.slice(2).join(' ').trim() : parts[1] ? parts[1].trim() : '';
  const value = desdobramento ? `${code}-${desdobramento}` : code;
  const naturezaPontuacaoLine = naturezaPontuacaoLines[index] || '';
  const { pontuacao, natureza } = parseNaturezaPontuacao(naturezaPontuacaoLine);
  return {
    value,
    label: `${value} - ${description}`,
    pontuacao,
    natureza,
  };
});

const pickDepartamentoFromRateio = (rateio) => {
  if (!Array.isArray(rateio) || rateio.length === 0) return { departamento: '', idsite: '' };
  const r0 = rateio[0] || {};
  const tipo = String(r0.tipo || '').toUpperCase();
  if (tipo === 'SITE') {
    return { departamento: 'Site', idsite: r0.idsite || '' };
  }
  return { departamento: r0.departamento || '', idsite: '' };
};

const normalizeMoney = (s) => {
  if (s == null) return '';
  const str = String(s).replace(/[^\d.,]/g, '');
  if (str.includes(',') && str.includes('.')) {
    return str.replace(/\./g, '').replace(',', '.');
  }
  return str.replace(',', '.');
};

const toDateTimeLocal = (input) => {
  if (!input) return '';
  let s = String(input).trim();
  s = s.replace(/\\\//g, '/');
  const mLocal = s.match(/^(\d{4}-\d{2}-\d{2})[T ](\d{2}):(\d{2})(?::\d{2})?/);
  if (mLocal) return `${mLocal[1]}T${mLocal[2]}:${mLocal[3]}`;
  const mBr = s.match(/^(\d{2})\/(\d{2})\/(\d{4})[ T](\d{2}):(\d{2})(?::\d{2})?/);
  if (mBr) {
    const [, dd, mm, yyyy, hh, mi] = mBr;
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }
  const mIsoSpace = s.match(/^(\d{4})-(\d{2})-(\d{2})[ ](\d{2}):(\d{2})(?::\d{2})?/);
  if (mIsoSpace) {
    const [, yyyy, mm, dd, hh, mi] = mIsoSpace;
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }
  const ts = Date.parse(s);
  if (!Number.isNaN(ts)) {
    const d = new Date(ts);
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');
    const hh = String(d.getHours()).padStart(2, '0');
    const mi = String(d.getMinutes()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }
  return '';
};

const toIsoSqlDatetime = (localDt) => {
  if (!localDt) return '';
  const m = String(localDt).match(/^(\d{4})-(\d{2})-(\d{2})T?(\d{2}):(\d{2})/);
  if (!m) return '';
  const [, yyyy, mm, dd, hh, mi] = m;
  return `${yyyy}-${mm}-${dd} ${hh}:${mi}:00`;
};

const norm = (s) =>
  (s || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
    .toUpperCase();

const PROJETO_OPTIONS = [
  'Frota',
  'ERICSSON - MG',
  'ERICSSON - NE',
  'ERICSSON - RJ',
  'ERICSSON - SP',
  'HUAWEI - MG',
  'HUAWEI - NE',
  'HUAWEI - RJ',
  'HUAWEI - SP',
  'TELEFONICA - MG',
  'TELEFONICA - NE',
  'TELEFONICA - NO',
  'TELEFONICA - SP',
  'ZTE - MG',
  'ZTE - NE',
  'ZTE - NO',
  'ZTE - RJ',
  'ZTE - SP',
].map((n) => ({ label: n, value: n }));

function TabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

const Multasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [telaexclusao, settelaexclusao] = useState('');
  const [idmultas, setidmultas] = useState('');
  const [nomeindicado, setnomeindicado] = useState('');
  const [placa, setplaca] = useState('');
  const [departamento, setdepartamento] = useState('');
  const [numeroait, setnumeroait] = useState('');
  const [datainfracao, setdatainfracao] = useState('');
  const [local, setlocal] = useState('');
  const [infracao, setinfracao] = useState('');
  const [valor, setvalor] = useState('');
  const [dataindicacao, setdataindicacao] = useState('');
  const [natureza, setnatureza] = useState('');
  const [pontuacao, setpontuacao] = useState('');
  const [datacolaborador, setdatacolaborador] = useState('');
  const [statusmulta, setstatusmulta] = useState('');
  const [idsite, setidsite] = useState('');
  const [projeto, setprojeto] = useState('Frota');

  const [idempresa, setidempresa] = useState(0);
  const [idpessoa, setidpessoa] = useState(0);

  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);
  const [selectedProjetoOption, setSelectedProjetoOption] = useState(PROJETO_OPTIONS[0]);

  const [empresalista, setempresalista] = useState([]);
  const [funcionariolista, setfuncionariolista] = useState([]);
  const [selectedInfracaoOption, setSelectedInfracaoOption] = useState(null);
  const [veiculoslista, setveiculoslista] = useState([]);
  const [departamentolista, setdepartamentolista] = useState([]);
  const [siteslista, setsiteslista] = useState([]);

  const [empresaNomeRef, setEmpresaNomeRef] = useState('');
  const [funcionarioNomeRef, setFuncionarioNomeRef] = useState('');

  const params = {
    idcliente: 1,
    idusuario: 1,
    idloja: 1,
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  const listamultas = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/multasid', { params });
      const { data } = response;

      setidmultas(asStr(data.idmultas));
      setnomeindicado(asUpper(data.nomeindicado || data.funcionario || ''));
      setplaca(asUpper(data.placa));
      setnumeroait(asUpper(data.numeroait));
      setdatainfracao(toDateTimeLocal(asStr(data.datainfracao)));
      setlocal(asUpper(data.local));
      setinfracao(asUpper(data.infracao));

      const valorBruto = data.valordespesa ?? data.valor;
      setvalor(asNumOrEmpty(valorBruto));

      setdataindicacao(asStr(data.dataindicacao));
      setnatureza(asUpper(data.natureza));
      setpontuacao(asStr(data.pontuacao));
      setdatacolaborador(asStr(data.datacolaborador));
      setstatusmulta(asUpper(data.statusmulta));

      const { departamento: depFromRateio, idsite: idsiteFromRateio } = pickDepartamentoFromRateio(data.rateio);
      const depFinal = depFromRateio || asStr(data.departamento);
      setdepartamento(depFinal);
      setidsite(depFinal === 'Site' ? asStr(idsiteFromRateio) : '');

      setidempresa(data.idempresa ?? 0);
      setidpessoa(data.idpessoa ?? 0);
      setEmpresaNomeRef(asStr(data.empresa));
      setFuncionarioNomeRef(asStr(data.funcionario));

      setselectedoptionempresa(
        data.idempresa ? { value: data.idempresa, label: asUpper(data.empresa || '') } : null
      );
      setselectedoptionfuncionario(
        data.idpessoa ? { value: data.idpessoa, label: asUpper(data.funcionario || '') } : null
      );

      const infracaoOption = infracaoOptions.find((option) => option.value === String(data.infracao).toUpperCase());
      setSelectedInfracaoOption(infracaoOption || null);
      if (infracaoOption) {
        setnatureza(infracaoOption.natureza || '');
        setpontuacao(infracaoOption.pontuacao || '');
      }

      const pj = asStr(data.projeto) || 'Frota';
      setprojeto(pj);
      const pjOpt = PROJETO_OPTIONS.find((o) => o.value === pj) || PROJETO_OPTIONS[0];
      setSelectedProjetoOption(pjOpt);

      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/empresas/selectpj', {
        params: { ...params, showinative: 'true' },
      });
      setempresalista(response.data || []);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listafuncionario = async (id) => {
    try {
      setloading(true);
      const response = await api.get(`v1/pessoa/selectfuncionario/${id}`, {
        params: { isOnlyCnh: 1, showinative: 'true' },
      });
      setfuncionariolista(response.data || []);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaveiculos = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/veiculos', { params });
      const lista = (response.data || []).map((item) => ({
        value: item.placa,
        label: item.placa,
        empresaId: item.idempresa,
        pessoaId: item.idpessoa,
      }));
      setveiculoslista(lista);
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listadepartamento = () => {
    const extras = ['Custo PJ', 'Frota'];
    const base = [...DEPARTAMENTOS_TELE_EQUIPE];
    extras.forEach((x) => {
      if (!base.includes(x)) base.push(x);
    });
    const lista = base.map((nome) => ({
      label: nome,
      value: nome,
    }));
    setdepartamentolista(lista);
  };

  const listasites = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/sites/select', { params });
      const lista = (response.data || []).map((s) => {
        const codigo = asStr(s.codigo || s.code || s.idsite || s.id || '');
        const nome = asStr(s.nome || s.name || '');
        const value = codigo || nome || '';
        return {
          value: String(value),
          label: `${codigo}${codigo && nome ? ' - ' : ''}${nome}`.trim(),
        };
      });
      setsiteslista(lista);
    } catch (err) {
      try {
        const fallback = await api.get('v1/sites', { params });
        const lista = (fallback.data || []).map((s) => {
          const codigo = asStr(s.codigo || s.code || s.idsite || s.id || '');
          const nome = asStr(s.nome || s.name || '');
          const value = codigo || nome || '';
          return {
            value: String(value),
            label: `${codigo}${codigo && nome ? ' - ' : ''}${nome}`.trim(),
          };
        });
        setsiteslista(lista);
      } catch (e2) {
        setmensagem(e2.message);
      }
    } finally {
      setloading(false);
    }
  };

  const handleempresa = (opt) => {
    if (opt) {
      setidempresa(opt.value);
      setselectedoptionempresa({ value: opt.value, label: opt.label });
      listafuncionario(opt.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa(null);
      setfuncionariolista([]);
      setselectedoptionfuncionario(null);
      setidpessoa(0);
    }
  };

  const handlefuncionario = (opt) => {
    if (opt) {
      setidpessoa(opt.value);
      setselectedoptionfuncionario({ value: opt.value, label: opt.label });
      setnomeindicado(asUpper(opt.label || ''));
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario(null);
      setnomeindicado('');
    }
  };

  const handleProjetoChange = (opt) => {
    if (opt) {
      setprojeto(opt.value);
      setSelectedProjetoOption(opt);
    } else {
      setprojeto('Frota');
      setSelectedProjetoOption(PROJETO_OPTIONS[0]);
    }
  };

  const handleInfracaoChange = (opt) => {
    if (opt) {
      setinfracao(String(opt.value).toUpperCase());
      setSelectedInfracaoOption(opt);
      setnatureza(opt.natureza?.trim() ? opt.natureza : 'NÃO SE APLICA');
      setpontuacao(opt.pontuacao?.trim() ? opt.pontuacao : '0');
    } else {
      setinfracao('');
      setSelectedInfracaoOption(null);
      setnatureza('NÃO SE APLICA');
      setpontuacao('0');
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');

    if (!placa || placa.trim() === '') {
      toast.error('O campo Placa é obrigatório.');
      return;
    }
    if (!datainfracao || datainfracao.trim() === '') {
      toast.error('O campo Data/Hora da Infração é obrigatório.');
      return;
    }
    if (!local || local.trim() === '') {
      toast.error('O campo Local Infração é obrigatório.');
      return;
    }
    if (!infracao) {
      toast.error('O campo Infração é obrigatório.');
      return;
    }
    if (!idempresa) {
      toast.error('Selecione uma Empresa.');
      return;
    }
    if (!idpessoa) {
      toast.error('Selecione um Nome Indicado.');
      return;
    }
    if (!departamento || departamento.trim() === '') {
      toast.error('O campo Departamento é obrigatório.');
      return;
    }
    if (departamento && departamento.toLowerCase() === 'site' && (!idsite || idsite.trim() === '')) {
      toast.error('O campo Site é obrigatório quando o Departamento for Site.');
      return;
    }

    const formattedDataindicacao = dataindicacao ? dataindicacao.trim() : '';
    const formattedDatacolaborador = datacolaborador ? datacolaborador.trim() : '';
    const valorNum = valor === '' ? null : Number(normalizeMoney(valor));

    const rateio =
      departamento === 'Site'
        ? [
          {
            percentual: 100.0,
            tipo: 'SITE',
            idsite: idsite ? idsite.trim() : null,
          },
        ]
        : [
          {
            percentual: 100.0,
            tipo: 'DEPARTAMENTO',
            departamento,
          },
        ];

    const data = {
      idmultas: ididentificador ? parseInt(ididentificador, 10) : null,
      idempresa: idempresa ? parseInt(idempresa, 10) : null,
      idpessoa: idpessoa ? parseInt(idpessoa, 10) : null,
      numeroait: numeroait ? String(numeroait).trim() : null,
      pontuacao: pontuacao ? parseInt(pontuacao, 10) : 0,
      nomeindicado,
      placa,
      datainfracao: toIsoSqlDatetime(datainfracao),
      local,
      infracao,
      valor: valorNum,
      valordespesa: valorNum,
      dataindicacao: formattedDataindicacao,
      natureza,
      datacolaborador: formattedDatacolaborador,
      statusmulta,
      idcliente: 1,
      idusuario: 1,
      idloja: 1,
      departamento,
      idsite: idsite ? idsite.trim() : null,
      projeto: projeto || 'Frota',
      rateio,
    };

    api
      .post('v1/multas', data)
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro salvo com sucesso!', { autoClose: 2000 });
          setTimeout(() => {
            setshow(false);
            togglecadastro();
            if (typeof atualiza === 'function') atualiza();
          }, 2000);
        } else {
          toast.error(`Erro: ${response.status}`);
        }
      })
      .catch((err) => {
        if (err.response?.data?.erro) {
          toast.error(`Erro: ${err.response.data.erro}`);
        } else {
          toast.error('Erro ao cadastrar a multa. Verifique os campos e tente novamente.');
        }
      });
  }

  const handleDepartamentoChange = useCallback((option) => {
    const value = option?.value ?? '';
    setdepartamento(value);
    setidsite((prev) => (value === 'Site' ? prev : ''));
  }, []);

  const handleSiteChange = useCallback((option) => {
    const value = option?.value ?? '';
    setidsite(value);
  }, []);

  const departamentoValue = useMemo(() => {
    return departamentolista.find((o) => o.value === departamento) ?? null;
  }, [departamentolista, departamento]);

  const siteValue = useMemo(() => {
    if (!idsite) return null;
    return siteslista.find((o) => String(o.value) === String(idsite)) ?? { value: idsite, label: idsite };
  }, [siteslista, idsite]);

  const iniciatabelas = () => {
    listaveiculos();
    setidmultas(asStr(ididentificador));
    listamultas();
    listaempresa();
    listadepartamento();
    listasites();
  };

  useEffect(() => {
    if (ididentificador) {
      iniciatabelas();
    }
  }, [ididentificador]);

  useEffect(() => {
    if (!Array.isArray(empresalista) || empresalista.length === 0) return;
    if (idempresa) {
      const byId = empresalista.find((o) => String(o.value) === String(idempresa));
      if (byId) {
        setselectedoptionempresa(byId);
        return;
      }
    }
    if (empresaNomeRef && !selectedoptionempresa) {
      const target = norm(empresaNomeRef);
      const byName =
        empresalista.find((o) => norm(o.label) === target) ||
        empresalista.find((o) => norm(o.label).includes(target)) ||
        empresalista.find((o) => target.includes(norm(o.label)));
      if (byName) {
        setidempresa(byName.value);
        setselectedoptionempresa(byName);
        listafuncionario(byName.value);
      }
    }
  }, [empresalista, idempresa, empresaNomeRef, selectedoptionempresa]);

  useEffect(() => {
    if (!Array.isArray(funcionariolista) || funcionariolista.length === 0) return;
    if (idpessoa) {
      const byId = funcionariolista.find((o) => String(o.value) === String(idpessoa));
      if (byId) {
        setselectedoptionfuncionario(byId);
        setnomeindicado(asUpper(byId.label || ''));
        return;
      }
    }
    if (funcionarioNomeRef && !selectedoptionfuncionario) {
      const target = norm(funcionarioNomeRef);
      const byName =
        funcionariolista.find((o) => norm(o.label) === target) ||
        funcionariolista.find((o) => norm(o.label).includes(target)) ||
        funcionariolista.find((o) => target.includes(norm(o.label)));
      if (byName) {
        setidpessoa(byName.value);
        setselectedoptionfuncionario(byName);
        setnomeindicado(asUpper(byName.label || ''));
      }
    }
  }, [funcionariolista, idpessoa, funcionarioNomeRef, selectedoptionfuncionario]);

  return (
    <>
      <Modal
        isOpen={show}
        toggle={togglecadastro}
        backdrop="static"
        keyboard={false}
        fade={false}
        className="modal-dialog modal-xl modal-fullscreen"
      >
        <ModalHeader toggle={togglecadastro} className="h1 fw-bold">
          Multas
        </ModalHeader>
        <ModalBody>
          {mensagem && (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          )}
          {mensagemsucesso && (
            <div className="alert alert-success" role="alert">
              Registro Salvo
            </div>
          )}
          {telaexclusao && (
            <Excluirregistro
              show={telaexclusao}
              setshow={settelaexclusao}
              ididentificador={ididentificador}
              quemchamou="PESSOAS"
            />
          )}
          {loading ? (
            <Loader />
          ) : (
            <div className="row g-6">
              <Col md="4">
                Placa
                <Select
                  isClearable
                  isSearchable
                  name="veiculo"
                  options={veiculoslista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={(opt) => setplaca(opt ? opt.value : '')}
                  value={veiculoslista.find((v) => v.value === placa) || null}
                />
              </Col>

              <Col md="4">
                <FormGroup>
                  Data/Hora da Infração
                  <Input
                    type="datetime-local"
                    step="60"
                    onChange={(e) => setdatainfracao(e.target.value)}
                    value={datainfracao ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="4">
                <FormGroup>
                  <Input
                    type="hidden"
                    onChange={(e) => setidmultas(e.target.value)}
                    value={idmultas ?? ''}
                    placeholder=""
                  />
                  Número AIT
                  <Input
                    type="text"
                    onChange={(e) => setnumeroait(asUpper(e.target.value))}
                    value={numeroait ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <div className="col-sm-6" style={{ marginBottom: '20px' }}>
                Empresa
                <Select
                  isClearable
                  isSearchable
                  name="empresa"
                  options={empresalista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleempresa}
                  value={selectedoptionempresa}
                />
              </div>

              <div className="col-sm-6">
                Nome do Indicado
                <Select
                  isClearable
                  isSearchable
                  name="funcionario"
                  options={Array.isArray(funcionariolista) ? funcionariolista : []}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handlefuncionario}
                  value={selectedoptionfuncionario}
                />
              </div>

              <Col md="12">
                <FormGroup>
                  Infração
                  <Select
                    isClearable
                    isSearchable
                    name="infracao"
                    options={infracaoOptions}
                    placeholder="Selecione"
                    onChange={handleInfracaoChange}
                    value={selectedInfracaoOption}
                  />
                </FormGroup>
              </Col>

              <Col md="12">
                <FormGroup>
                  Local Infração
                  <Input
                    type="text"
                    onChange={(e) => setlocal(asUpper(e.target.value))}
                    value={local ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Valor
                  <Input
                    type="number"
                    onChange={(e) => {
                      const v = e.target.value;
                      setvalor(v);
                    }}
                    value={valor === '' ? '' : valor}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Pontuação
                  <Input type="text" value={pontuacao ?? ''} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="8">
                <FormGroup>
                  Natureza
                  <Input type="text" value={asUpper(natureza)} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="6">
                <FormGroup>
                  Status
                  <Input
                    type="text"
                    onChange={(e) => setstatusmulta(asUpper(e.target.value))}
                    value={statusmulta ?? ''}
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data Limite para Indicação
                  <Input
                    type="date"
                    onChange={(e) => setdataindicacao(e.target.value)}
                    value={dataindicacao ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data Envio para Colaborador
                  <Input
                    type="date"
                    onChange={(e) => setdatacolaborador(e.target.value)}
                    value={datacolaborador ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="6">
                Projeto
                <Select
                  isClearable
                  isSearchable
                  name="projeto"
                  options={PROJETO_OPTIONS}
                  placeholder="Selecione"
                  onChange={handleProjetoChange}
                  value={selectedProjetoOption}
                />
              </Col>

              <Col md="6">
                Departamento
                <Select
                  isClearable
                  isSearchable
                  name="departamento"
                  options={departamentolista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleDepartamentoChange}
                  value={departamentoValue}
                />
              </Col>

              {departamento === 'Site' && (
                <Col md="12">
                  <FormGroup>
                    Site
                    <Select
                      isClearable
                      isSearchable
                      name="site"
                      options={siteslista}
                      placeholder="Selecione o site (nome ou código)"
                      isLoading={loading}
                      onChange={handleSiteChange}
                      value={siteValue}
                    />
                  </FormGroup>
                </Col>
              )}
            </div>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>

      <ToastContainer
        position="top-right"
        autoClose={5000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        containerStyle={{ zIndex: 99999 }}
      />
    </>
  );
};

Multasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.func,
};

export default Multasedicao;
