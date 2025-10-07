import { useState, useEffect, useMemo } from 'react';
import PropTypes from 'prop-types';
import { Box } from '@mui/material';
import Typography from '@mui/material/Typography';
import { Col, Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import Select from 'react-select';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import S3Service from '../../../services/s3Service';
import modoVisualizador from '../../../services/modovisualizador';

// --- Custom MultiValue (sem defaultProps) para React 19 ---
const CustomMultiValue = ({ children, innerProps, removeProps }) => {
  return (
    <div
      {...innerProps}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 6,
        padding: '2px 6px',
        borderRadius: 6,
        border: '1px solid #e0e0e0',
        background: '#f5f5f5',
        margin: 2,
      }}
    >
      <span>{children}</span>
      <button
        type="button"
        aria-label="Remover"
        {...removeProps}
        style={{
          border: 'none',
          background: 'transparent',
          cursor: 'pointer',
          lineHeight: 1,
        }}
      >
        ×
      </button>
    </div>
  );
};

CustomMultiValue.propTypes = {
  children: PropTypes.node,
  innerProps: PropTypes.object,
  removeProps: PropTypes.object,
};

// Opcional: estilo para o container dos valores
const multiStyles = {
  multiValue: (base) => ({
    ...base,
    backgroundColor: 'transparent',
  }),
  multiValueLabel: (base) => ({
    ...base,
    color: 'inherit',
    padding: 0,
  }),
  multiValueRemove: (base) => ({
    ...base,
    display: 'none',
  }),
};

let s3Service;

const fetchS3Credentials = async () => {
  try {
    const response = await api.get('v1/credenciaiss3');
    if (response.status === 200) {
      const { acesskeyid, secretkey, region, bucketname } = response?.data[0];
      s3Service = new S3Service({
        region,
        accessKeyId: acesskeyid,
        secretAccessKey: secretkey,
        bucketName: bucketname,
      });
    }
  } catch {
    console.log('Erro ao obter credenciais S3');
  }
};

function TabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div role="tabpanel" hidden={value !== index} id={`simple-tabpanel-${index}`} aria-labelledby={`simple-tab-${index}`} {...other}>
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

const regionaisBase = [
  { value: 'DEP:ERICSSON - MG', label: 'ERICSSON - MG' },
  { value: 'DEP:ERICSSON - NE', label: 'ERICSSON - NE' },
  { value: 'DEP:ERICSSON - RJ', label: 'ERICSSON - RJ' },
  { value: 'DEP:ERICSSON - SP', label: 'ERICSSON - SP' },
  { value: 'DEP:HUAWEI - MG', label: 'HUAWEI - MG' },
  { value: 'DEP:HUAWEI - NE', label: 'HUAWEI - NE' },
  { value: 'DEP:HUAWEI - RJ', label: 'HUAWEI - RJ' },
  { value: 'DEP:HUAWEI - SP', label: 'HUAWEI - SP' },
  { value: 'DEP:TELEFONICA - MG', label: 'TELEFONICA - MG' },
  { value: 'DEP:TELEFONICA - NE', label: 'TELEFONICA - NE' },
  { value: 'DEP:TELEFONICA - NO', label: 'TELEFONICA - NO' },
  { value: 'DEP:TELEFONICA - SP', label: 'TELEFONICA - SP' },
  { value: 'DEP:ZTE - MG', label: 'ZTE - MG' },
  { value: 'DEP:ZTE - NE', label: 'ZTE - NE' },
  { value: 'DEP:ZTE - NO', label: 'ZTE - NO' },
  { value: 'DEP:ZTE - RJ', label: 'ZTE - RJ' },
  { value: 'DEP:ZTE - SP', label: 'ZTE - SP' },
];

const Despesasedicao = ({
  setshow,
  show,
  ididentificador = 0,
  atualiza = null,
  selectedLancarDespesas = null,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(true);
  const [empresalista, setempresalista] = useState([]);
  const [veiculoslista, setveiculoslista] = useState([]);
  const [iddespesas, setiddespesas] = useState();
  const [datalancamento, setdatalancamento] = useState(() => {
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    return ontem.toISOString().split('T')[0];
  });
  const [valordespesa, setvalordespesa] = useState('');
  const [descricao, setdescricao] = useState('');
  const [comprovante, setcomprovante] = useState('');
  const [observacao, setobservacao] = useState('');
  const [idempresa, setidempresa] = useState();
  const [idveiculo, setidveiculo] = useState();
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionveiculo, setselectedoptionveiculo] = useState(null);
  const [funcionariolista, setfuncionariolista] = useState([]);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);
  const [idpessoa, setidpessoa] = useState('');
  const [file, setFile] = useState(null);
  const [uploadedFiles, setUploadedFiles] = useState([]);
  const [periodicidade, setPeriodicidade] = useState('');
  const [categoriaDespesa, setCategoriaDespesa] = useState('');
  const [parceladoEm, setParceladoEm] = useState('');
  const [valordaparcela, setvalordaparcela] = useState('');
  const [dataInicio, setDataInicio] = useState('');
  const [siteInput, setSiteInput] = useState('');
  const [sitesOptions, setSitesOptions] = useState([]);
  const [alocacoesSelecionadas, setAlocacoesSelecionadas] = useState([]);
  const [rateioItens, setRateioItens] = useState([]);

  const params = {
    idcliente: 1,
    idusuario: 1,
    idloja: 1,
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const listFilesFromS3 = async (id) => {
    try {
      const prefix = `despesas/${id}/`;
      const files = await s3Service.listFiles(prefix);
      const fileUrls = await Promise.all(
        files.map(async (filee) => {
          const url = await s3Service.getFileUrl(filee.Key);
          return { name: filee.Key.split('/').pop(), url, key: filee.Key };
        }),
      );
      setUploadedFiles(fileUrls);
    } catch {
      console.log('Erro ao listar arquivos no S3');
    }
  };

  const listafuncionario = async (id) => {
    try {
      setloading(true);
      const res = await api.get(`v1/pessoa/selectfuncionario/${id}`);
      setfuncionariolista(res.data);
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
      const res = await api.get('v1/empresas/selectpj', { params });
      setempresalista(res.data ?? null);
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
      const lista = response.data.map((item) => ({
        value: item.id,
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

  const iniciatabelas = async () => {
    try {
      setloading(true);
      await Promise.all([listaempresa(), listaveiculos()]);
    } catch {
      setmensagem('Erro ao carregar os dados iniciais.');
    } finally {
      setloading(false);
    }
  };

  function initialPage() {
    const initializeS3Service = async () => {
      await fetchS3Credentials();
      iniciatabelas();
    };
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    const data = ontem.toISOString().split('T')[0];
    setdatalancamento(data);
    initializeS3Service();
  }

  const parseSiteId = (raw) => {
    const s = String(raw).trim();
    if (!s) return '';
    const m = s.match(/^(?:SITE[\s:-]+)?(.+)$/i);
    return m ? m[1].trim() : '';
  };

  const addSite = () => {
    const id = parseSiteId(siteInput);
    if (!id) return;
    const value = `SITE:${id}`;
    const label = `SITE-${id}`;
    const existsInOptions = sitesOptions.some((o) => o.value === value);
    const existsInSelection = alocacoesSelecionadas.some((o) => o.value === value);
    if (!existsInOptions) {
      setSitesOptions((prev) => [...prev, { value, label }]);
    }
    if (!existsInSelection) {
      setAlocacoesSelecionadas((prev) => [...prev, { value, label }]);
    }
    setSiteInput('');
  };

  const removeSiteOption = (value) => {
    setSitesOptions((prev) => prev.filter((o) => o.value !== value));
    setAlocacoesSelecionadas((prev) => prev.filter((o) => o.value !== value));
    setRateioItens((prev) => prev.filter((i) => i.key !== value));
  };

  const combinedOptions = useMemo(() => [...regionaisBase, ...sitesOptions], [sitesOptions]);

  const listadespesas = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/despesasid', { params });
      const { data } = response;
      if (!data?.iddespesas) return;

      const id = data.iddespesas || ididentificador;
      await listFilesFromS3(id);

      const veiculoSelecionado = veiculoslista.find((item) => Number(item?.value) === Number(data.idveiculo));
      setselectedoptionveiculo({
        value: veiculoSelecionado?.value || '',
        label: veiculoSelecionado?.label || '',
      });

      setiddespesas(data.iddespesas);
      setdatalancamento(data.datalancamento);
      setvalordespesa(data.valordespesa);
      setdescricao(data.descricao);
      setcomprovante(data.comprovante);
      setobservacao(data.observacao);
      setidempresa(data.idempresa);
      setidveiculo(data.idveiculo);
      setvalordaparcela(data.valorparcela);
      setParceladoEm(data.parceladoem);
      setPeriodicidade(data.periodicidade);
      setDataInicio(data.datainicio);
      setCategoriaDespesa(data.categoria);
      setidpessoa(data.idpessoa);
      setmensagem('');

      if (data.idempresa) {
        listafuncionario(data.idempresa);
        setselectedoptionempresa({ value: data.idempresa, label: data.empresa });
      }

      if (Array.isArray(data.rateio) && data.rateio.length > 0) {
        const siteOpts = data.rateio
          .filter((r) => r.tipo === 'SITE' && r.idsite != null)
          .map((r) => ({ value: `SITE:${r.idsite}`, label: `SITE-${r.idsite}` }));
        if (siteOpts.length) {
          setSitesOptions((prev) => {
            const mapPrev = new Map(prev.map((o) => [o.value, o]));
            siteOpts.forEach((o) => mapPrev.set(o.value, o));
            return Array.from(mapPrev.values());
          });
        }

        const selections = data.rateio.map((r) =>
          r.tipo === 'DEPARTAMENTO'
            ? { value: `DEP:${r.departamento}`, label: r.departamento }
            : { value: `SITE:${r.idsite}`, label: `SITE-${r.idsite}` },
        );
        setAlocacoesSelecionadas(selections);

        setRateioItens(
          data.rateio.map((r) =>
            r.tipo === 'DEPARTAMENTO'
              ? {
                key: `DEP:${r.departamento}`,
                tipo: 'DEPARTAMENTO',
                iddepartamento: r.departamento,
                idsite: null,
                label: r.departamento,
                percentual: String(r.percentual ?? ''),
              }
              : {
                key: `SITE:${r.idsite}`,
                tipo: 'SITE',
                iddepartamento: null,
                idsite: String(r.idsite),
                label: `SITE-${r.idsite}`,
                percentual: String(r.percentual ?? ''),
              },
          ),
        );
      } else {
        setAlocacoesSelecionadas([]);
        setRateioItens([]);
      }
    } catch (err) {
      setmensagem(err.message || 'Erro inesperado ao buscar despesas.');
    } finally {
      setloading(false);
    }
  };

  useEffect(() => {
    setRateioItens((prev) => {
      const prevMap = new Map(prev.map((p) => [p.key, p]));
      const next = [];
      alocacoesSelecionadas.forEach((opt) => {
        const val = String(opt.value);
        if (val.startsWith('DEP:')) {
          const depName = val.slice(4);
          const key = `DEP:${depName}`;
          const found = prevMap.get(key);
          next.push(
            found
              ? { ...found, tipo: 'DEPARTAMENTO', iddepartamento: depName, label: depName }
              : { key, tipo: 'DEPARTAMENTO', iddepartamento: depName, idsite: null, label: depName, percentual: '' },
          );
        } else if (val.startsWith('SITE:')) {
          const siteId = val.slice(5);
          const key = `SITE:${siteId}`;
          const found = prevMap.get(key);
          next.push(
            found
              ? { ...found, tipo: 'SITE', idsite: siteId, label: `SITE-${siteId}` }
              : { key, tipo: 'SITE', iddepartamento: null, idsite: siteId, label: `SITE-${siteId}`, percentual: '' },
          );
        }
      });
      return next;
    });
  }, [alocacoesSelecionadas]);

  useEffect(() => {
    listadespesas();
    if (selectedLancarDespesas) {
      const veiculoSelecionado = veiculoslista.find((item) => Number(item?.value) === Number(selectedLancarDespesas.id));
      setselectedoptionveiculo({
        value: veiculoSelecionado?.value || '',
        label: veiculoSelecionado?.label || '',
      });
      setidveiculo(veiculoSelecionado?.value || veiculoSelecionado?.label);
      if (selectedLancarDespesas.idempresa) {
        listafuncionario(selectedLancarDespesas.idempresa);
        const empresa = empresalista.find((item) => Number(item?.value) === Number(selectedLancarDespesas.idempresa));
        setselectedoptionempresa({
          value: empresa?.value || '',
          label: empresa?.label || '',
        });
      }
    }
  }, [veiculoslista, empresalista]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    if (iddespesas) {
      const id = iddespesas || ididentificador;
      listFilesFromS3(id);
    }
  }, [iddespesas]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    initialPage();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    if (idempresa && empresalista && empresalista.length > 0) {
      const empresaSelecionada = empresalista.find((e) => e.value === idempresa);
      setselectedoptionempresa(empresaSelecionada || null);
    }
  }, [idempresa, empresalista]);

  useEffect(() => {
    if (idpessoa && funcionariolista && funcionariolista.length > 0) {
      const funcionarioSelecionado = funcionariolista.find((f) => f.value === idpessoa);
      setselectedoptionfuncionario(funcionarioSelecionado || null);
    }
  }, [funcionariolista, idpessoa]);

  const togglecadastro = () => setshow(false);

  const validarCampos = () => {
    if (!datalancamento) {
      const ontem = new Date();
      ontem.setDate(ontem.getDate());
      setdatalancamento(ontem.toISOString().split('T')[0]);
    }
    if (!valordespesa) {
      setmensagem("O campo 'Valor da Despesa' é obrigatório.");
      return false;
    }
    if (!idveiculo) {
      setmensagem("O campo 'Veículo' é obrigatório.");
      return false;
    }
    if (!categoriaDespesa) {
      setmensagem("O campo 'Categoria da Despesa' é obrigatório.");
      return false;
    }
    if (!periodicidade) {
      setmensagem("O campo 'Periodicidade' é obrigatório.");
      return false;
    }
    if (periodicidade !== 'Unica') {
      if (!parceladoEm) {
        setmensagem("O campo 'Parcelado em' é obrigatório.");
        return false;
      }
      if (!valordaparcela) {
        setmensagem("O campo 'Valor da Parcela' é obrigatório para despesas parceladas.");
        return false;
      }
      if (parceladoEm < 2) {
        setmensagem('O número de parcelas deve ser 2 ou mais.');
        return false;
      }
    }
    if (rateioItens.length === 0) {
      setmensagem('Adicione pelo menos um departamento ou um site ao rateio.');
      return false;
    }
    const soma = rateioItens.reduce((acc, cur) => {
      const v = parseFloat(String(cur.percentual).replace(',', '.')) || 0;
      return acc + v;
    }, 0);
    const arred = Math.round(soma * 100) / 100;
    if (arred !== 100) {
      setmensagem('A soma dos percentuais deve ser igual a 100%.');
      return false;
    }
    return true;
  };

  function moedaParaNumero(valorFormatado) {
    if (!valorFormatado) return 0;
    let valorLimpo = valorFormatado.replace(/[R$\s\\.]/g, '');
    valorLimpo = valorLimpo.replace(',', '.');
    const valorNumerico = parseFloat(valorLimpo);
    return Number.isNaN(valorNumerico) ? 0 : valorNumerico;
  }

  function ProcessaCadastro(e) {
    e.preventDefault();
    const ontem = new Date();
    ontem.setDate(ontem.getDate());
    const dataNow = ontem.toISOString().split('T')[0];

    if (!validarCampos()) return;

    if (periodicidade !== 'Unica') {
      const totalParcelas = Math.round(parceladoEm * Number(String(valordaparcela).replace(',', '.')) * 100) / 100;
      const totalInformado = Math.round(Number(String(valordespesa).replace(',', '.')) * 100) / 100;
      if (totalInformado !== totalParcelas) {
        setmensagem('Valor da parcela multiplicado pelo número de parcelas não é igual ao valor total.');
        return;
      }
    }

    setmensagem('');
    setmensagemsucesso('');
    setloading(true);

    const payloadRateio = rateioItens.map((r) => ({
      tipo: r.tipo,
      iddepartamento: r.tipo === 'DEPARTAMENTO' ? r.iddepartamento : null,
      idsite: r.tipo === 'SITE' ? r.idsite : null,
      percentual: parseFloat(String(r.percentual).replace(',', '.')) || 0,
    }));

    api
      .post('v1/despesas', {
        iddespesas: ididentificador,
        datalancamento: datalancamento ?? dataNow,
        valordespesa,
        descricao,
        comprovante,
        observacao,
        idveiculo,
        dataInicio,
        valordaparcela: moedaParaNumero(valordaparcela),
        parceladoEm,
        categoria: categoriaDespesa,
        periodicidade,
        idempresa,
        idpessoa,
        rateio: payloadRateio,
        despesacadastradapor: localStorage.getItem('sessionNome'),
        idcliente: 1,
        idusuario: 1,
        idloja: 1,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setTimeout(() => {
            if (atualiza) atualiza();
            initialPage();
          }, 1000);
          togglecadastro.bind(null);
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      })
      .finally(() => {
        setloading(false);
      });
  }

  const handlefuncionario = (stat) => {
    if (stat !== null) {
      setidpessoa(stat.value);
      setselectedoptionfuncionario({ value: stat.value, label: stat.label });
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario({ value: null, label: null });
    }
  };

  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
      listafuncionario(stat.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa({ value: null, label: null });
    }
  };

  const handleveiculo = (stat) => {
    if (stat !== null) {
      setidveiculo(stat.value);
      if (stat.empresaId) {
        setidempresa(stat.empresaId);
        listafuncionario(stat.empresaId);
        if (stat.pessoaId) {
          setidpessoa(stat.pessoaId);
        } else {
          setidpessoa(null);
          setselectedoptionfuncionario(null);
        }
      } else {
        setidempresa(null);
        setselectedoptionempresa(null);
        setidpessoa(null);
        setselectedoptionfuncionario(null);
      }
      setselectedoptionveiculo({ value: stat.value, label: stat.label });
    } else {
      setidveiculo(0);
      setselectedoptionveiculo(null);
      setidempresa(null);
      setselectedoptionempresa(null);
      setidpessoa(null);
      setselectedoptionfuncionario(null);
    }
  };

  const handleFileUpload = async () => {
    if (file) {
      try {
        const key = `despesas/${ididentificador}/${file.name}`;
        await s3Service.uploadFile(file, key);
        const url = await s3Service.getFileUrl(key);
        setUploadedFiles((prev) => [...prev, { name: file.name, url, key }]);
        const id = ididentificador;
        listFilesFromS3(id);
      } catch {
        console.log('Erro ao enviar arquivo ao S3');
      }
    }
  };

  const handleDeleteFile = async (fileKey) => {
    try {
      await s3Service.deleteFile(fileKey);
      setUploadedFiles((prev) => prev.filter((uploadedFile) => uploadedFile.key !== fileKey));
    } catch {
      console.log('Erro ao deletar arquivo no S3');
    }
  };

  const handleGenerateDownloadLink = async (fileName) => {
    try {
      const key = `despesas/${ididentificador}/${fileName}`;
      const url = await s3Service.getFileUrl(key);
      if (!url) throw new Error('URL não gerado corretamente');
      const link = document.createElement('a');
      link.href = url;
      link.download = fileName;
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch {
      console.log('Erro ao gerar link de download');
    }
  };

  const somaPercentuais = useMemo(() => {
    const soma = rateioItens.reduce((acc, cur) => acc + (parseFloat(String(cur.percentual).replace(',', '.')) || 0), 0);
    return Math.round(soma * 100) / 100;
  }, [rateioItens]);

  const handlePercentualChange = (key, value) => {
    setRateioItens((prev) => prev.map((i) => (i.key === key ? { ...i, percentual: value } : i)));
    setmensagem('');
  };

  const removerItemRateio = (key) => {
    setAlocacoesSelecionadas((prev) => prev.filter((o) => o.value !== key));
    setRateioItens((prev) => prev.filter((i) => i.key !== key));
  };

  // IDs para associar labels (acessibilidade)
  const allocSelectId = 'alocacoes-select';
  const siteInputId = 'site-input';
  const rateioLabelId = 'rateio-label';

  return (
    <Modal isOpen={show} toggle={togglecadastro.bind(null)} backdrop="static" keyboard={false} className="modal-dialog modal-xl modal-fullscreen ">
      <ModalHeader style={{ backgroundColor: 'white' }} toggle={togglecadastro.bind(null)}>
        Cadastro de Despesas
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
        {mensagem.length > 0 ? <div className="alert alert-danger mt-2" role="alert">{mensagem}</div> : null}
        {mensagemsucesso.length > 0 ? <div className="alert alert-success" role="alert">Registro Salvo</div> : null}
        {loading ? (
          <Loader />
        ) : (
          <>
            <div className="row g-3">
              <Col md="3">
                <FormGroup>
                  <Input type="hidden" onChange={(e) => setiddespesas(e.target.value)} value={iddespesas} placeholder="" />
                  Data do Lançamento
                  <Input type="date" onChange={(e) => setdatalancamento(e.target.value)} value={datalancamento} min="2022-12-01" />
                </FormGroup>
              </Col>

              <div className="col-sm-3">
                Veículos
                <Select
                  isClearable
                  isSearchable
                  name="veiculo"
                  options={veiculoslista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleveiculo}
                  value={selectedoptionveiculo}
                />
              </div>

              <div className="col-sm-3">
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

              <div className="col-sm-3">
                Funcionário
                <Select
                  isClearable
                  isSearchable
                  name="funcionario"
                  options={funcionariolista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handlefuncionario}
                  value={selectedoptionfuncionario}
                />
              </div>

              <Col md="3">
                <FormGroup>
                  Categoria
                  <Input type="select" onChange={(e) => setCategoriaDespesa(e.target.value)} value={categoriaDespesa}>
                    <option value="">Selecione</option>
                    <option value="Combustível">COMBUSTÍVEL</option>
                    <option value="Locação">LOCAÇÃO</option>
                    <option value="Manutenção">MANUTENÇÃO</option>
                    <option value="Pedágio">PEDÁGIO</option>
                    <option value="Outros">OUTROS</option>
                  </Input>
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Periodicidade
                  <Input
                    type="select"
                    onChange={(e) => {
                      if (e.target.value === 'Unica') {
                        setParceladoEm('1');
                        setvalordaparcela(valordespesa);
                      } else {
                        setParceladoEm('2');
                        setvalordaparcela('');
                      }
                      setPeriodicidade(e.target.value);
                    }}
                    value={periodicidade}
                  >
                    <option value="">Selecione</option>
                    <option value="Unica">Unica</option>
                    <option value="Mensal">MENSAL</option>
                    <option value="Bimestral">BIMESTRAL</option>
                    <option value="Trimestral">TRIMESTRAL</option>
                    <option value="Anual">ANUAL</option>
                  </Input>
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Parcelado em
                  <Input
                    type="number"
                    min={1}
                    disabled={periodicidade === 'Unica'}
                    onChange={(e) => {
                      if (valordaparcela) {
                        const value = e.target.value * (parseFloat(String(valordaparcela).replace(',', '.')) || 0);
                        setvalordespesa(value ? value.toFixed(2) : '');
                      }
                      setParceladoEm(e.target.value);
                    }}
                    value={parceladoEm}
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Valor da parcela
                  <Input
                    type="text"
                    onChange={(e) => {
                      const raw = e.target.value;
                      const multi = parseInt(parceladoEm || '0', 10) || 0;
                      const unit = parseFloat(String(raw).replace(',', '.')) || 0;
                      const total = unit * multi;
                      setvalordespesa(total ? total.toFixed(2) : '');
                      setvalordaparcela(raw);
                    }}
                    value={valordaparcela}
                    placeholder="Ex: 100,10"
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data do inicio do pagamento
                  <Input type="date" onChange={(e) => setDataInicio(e.target.value)} value={dataInicio} />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Valor Total
                  <Input type="text" disabled value={valordespesa} placeholder="R$ 0,00" />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Descrição da Despesa
                  <Input type="text" onChange={(e) => setdescricao(e.target.value)} value={descricao} />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Comprovante
                  <Input type="text" onChange={(e) => setcomprovante(e.target.value)} value={comprovante} placeholder="Comprovante" />
                </FormGroup>
              </Col>
            </div>

            <div className="row g-3 mt-2">
              <Col md="12">
                <FormGroup>
                  {/* Label para Departamentos e Sites */}
                  Departamentos e Sites
                  <div className="d-flex align-items-end gap-2">
                    <div className="flex-grow-1">
                      <Select
                        inputId={allocSelectId}
                        instanceId={allocSelectId}
                        isMulti
                        isClearable
                        isSearchable
                        name="alocacoes"
                        options={combinedOptions}
                        placeholder="Selecione departamentos e sites"
                        value={alocacoesSelecionadas}
                        onChange={(vals) => setAlocacoesSelecionadas(vals || [])}
                        components={{ MultiValue: CustomMultiValue }}
                        styles={multiStyles}
                      />
                    </div>
                  </div>

                  <div className="d-flex gap-2 mt-2 align-items-end">
                    <div className="flex-grow-1">
                      Site
                      <Input
                        id={siteInputId}
                        type="text"
                        placeholder='Adicionar Site (ex.: "123" ou "SITE-123")'
                        value={siteInput}
                        onChange={(e) => setSiteInput(e.target.value)}
                      />
                    </div>
                    <div>
                      <Button color="primary" onClick={addSite} style={{ marginTop: 24 }}>
                        Adicionar Site
                      </Button>
                    </div>
                  </div>

                  {sitesOptions.length > 0 && (
                    <div className="mt-2 d-flex flex-wrap gap-2">
                      {sitesOptions.map((s) => (
                        <div key={s.value} className="badge bg-light text-dark d-flex align-items-center" style={{ gap: 8 }}>
                          {s.label}
                          <Button size="sm" color="danger" onClick={() => removeSiteOption(s.value)}>x</Button>
                        </div>
                      ))}
                    </div>
                  )}
                </FormGroup>
              </Col>
            </div>

            <div className="row g-3">
              <div className="col-sm-12">
                {/* Label para Rateio */}
                Rateio
                <table className="table table-white-bg" aria-labelledby={rateioLabelId}>
                  <thead>
                    <tr>
                      <th>Tipo</th>
                      <th>Identificador</th>
                      <th>Percentual (%)</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {rateioItens.map((item) => (
                      <tr key={item.key}>
                        <td>{item.tipo}</td>
                        <td>{item.label}</td>
                        <td style={{ maxWidth: 160 }}>
                          <Input
                            type="number"
                            min="0"
                            step="0.01"
                            value={item.percentual}
                            onChange={(e) => handlePercentualChange(item.key, e.target.value)}
                            placeholder="0"
                          />
                        </td>
                        <td>
                          <Button color="danger" onClick={() => removerItemRateio(item.key)}>Remover</Button>
                        </td>
                      </tr>
                    ))}
                    {rateioItens.length > 0 && (
                      <tr>
                        <td colSpan={2} className="text-end">
                          <strong>Total</strong>
                        </td>
                        <td>
                          <strong>{somaPercentuais.toFixed(2)}</strong>
                        </td>
                        <td></td>
                      </tr>
                    )}
                  </tbody>
                </table>
                {rateioItens.length > 0 && somaPercentuais !== 100 && (
                  <div className="alert alert-warning">A soma dos percentuais deve ser igual a 100%.</div>
                )}
              </div>
            </div>

            <div className="row g-3 mt-2">
              <FormGroup>
                Observação
                <Input
                  className="form-control"
                  type="textarea"
                  name="observacao"
                  id="observacao"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                />
              </FormGroup>
            </div>

            <div className="row g-3">
              <Col md="6">
                <FormGroup>
                  <div className="d-flex align-items-center">
                    <Input type="file" onChange={(e) => setFile(e.target.files[0])} />
                    <Button color="primary" onClick={handleFileUpload} className="ms-0" disabled={!ididentificador}>Upload</Button>
                  </div>
                  {!ididentificador && (
                    <div className="mt-2 mt-md-0 ms-md-2 small text-muted">
                      Salve a despesa para adicionar os novos arquivos.
                    </div>
                  )}
                </FormGroup>
              </Col>
            </div>

            <div style={{ backgroundColor: 'white' }}>
              <div className="col-sm-12">
                <div className="d-flex flex-row-reverse custom-file">
                  <table className="table table-white-bg">
                    <thead>
                      <tr>
                        <th>Nome do arquivo</th>
                        <th>Download</th>
                        <th>Delete</th>
                      </tr>
                    </thead>
                    <tbody>
                      {uploadedFiles.map((uploadedFile) => (
                        <tr key={uploadedFile.key || uploadedFile.url || uploadedFile.name}>
                          <td>{uploadedFile.name}</td>
                          <td>
                            <Button color="primary" onClick={() => handleGenerateDownloadLink(uploadedFile.name)}>
                              Download
                            </Button>
                          </td>
                          <td>
                            <Button color="danger" onClick={() => handleDeleteFile(uploadedFile.key)}>
                              Delete
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>Salvar</Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>Sair</Button>
      </ModalFooter>
    </Modal>
  );
};

Despesasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.func,
  selectedLancarDespesas: PropTypes.object,
};

export default Despesasedicao;
