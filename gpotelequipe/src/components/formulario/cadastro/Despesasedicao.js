import { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import PropTypes from 'prop-types';
import { Box } from '@mui/material';
import Typography from '@mui/material/Typography';
import { Col, Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import Select from 'react-select';
import AsyncSelect from 'react-select/async';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import S3Service from '../../../services/s3Service';
import modoVisualizador from '../../../services/modovisualizador';

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
  const [datalancamento, setdatalancamento] = useState(() => new Date().toISOString().split('T')[0]);
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

  const [sitesOptions, setSitesOptions] = useState([]);
  const [alocacoesSelecionadas, setAlocacoesSelecionadas] = useState([]);
  const [rateioItens, setRateioItens] = useState([]);

  const [departamentos, setDepartamentos] = useState([]);

  const [idmulta, setIdmulta] = useState(null);
  const isEditing = !!iddespesas;
  const isFromMulta = !!idmulta;

  const [projetos, setProjetos] = useState([]);
  const projetoOptions = useMemo(
    () =>
      Array.isArray(projetos)
        ? projetos.map((p) => ({
          value: p?.id ?? p?.ID ?? p?.value ?? null,
          label: p?.nome ?? p?.NOME ?? p?.label ?? String(p ?? ''),
        }))
        : [],
    [projetos]
  );
  const [selectedProjeto, setSelectedProjeto] = useState(null);

  const mountedRef = useRef(true);
  const debounceRef = useRef(null);

  const params = {
    idcliente: 1,
    idusuario: 1,
    idloja: 1,
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const debounce = useCallback((fn, delay = 300) => {
    return (...args) =>
      new Promise((resolve) => {
        if (debounceRef.current) clearTimeout(debounceRef.current);
        debounceRef.current = setTimeout(async () => {
          const result = await fn(...args);
          resolve(result);
        }, delay);
      });
  }, []);

  const loadSites = useMemo(
    () =>
      debounce(async (inputValue) => {
        const q = inputValue?.trim() || '';
        try {
          const res = await api.get('v1/rollout/unificado', {
            params: { ...params, q, limit: 50 },
          });
          const data = Array.isArray(res.data) ? res.data : [];
          return data.map((item) => ({
            value: item.chave || item.site || item.id,
            label: item.site || item.chave || item.nome || `SITE-${item.id}`,
          }));
        } catch {
          return [];
        }
      }, 300),
    [params, debounce]
  );

  const listFilesFromS3 = async (id) => {
    try {
      const prefix = `despesas/${id}/`;
      const files = await s3Service.listFiles(prefix);
      const fileUrls = await Promise.all(
        files.map(async (filee) => {
          const url = await s3Service.getFileUrl(filee.Key);
          return { name: filee.Key.split('/').pop(), url, key: filee.Key };
        })
      );
      if (mountedRef.current) setUploadedFiles(fileUrls);
    } catch {
      console.log('Erro ao listar arquivos no S3');
    }
  };

  const listafuncionario = async (id) => {
    try {
      const res = await api.get(`v1/pessoa/selectfuncionario/${id}`);
      if (mountedRef.current) {
        setfuncionariolista(res.data ?? []);
        setmensagem('');
      }
    } catch (err) {
      if (mountedRef.current) setmensagem(err.message);
    }
  };

  const listaDespesasFrota = async () => {
    try {
      const res = await api.get('v1/despesas/despesasfrotas');
      const data = Array.isArray(res.data) ? res.data : [];
      setProjetos(data);
    } catch (err) {
      setmensagem(err.message);
    }
  };

  const listaDespesasDepartamento = async () => {
    try {
      const res = await api.get('v1/despesas/departamentos');
      const data = Array.isArray(res.data) ? res.data : [];
      setDepartamentos(data);
    } catch (err) {
      setmensagem(err.message);
    }
  };

  const listaempresa = async () => {
    try {
      const res = await api.get('v1/empresas/selectpj', { params });
      return res.data ?? [];
    } catch (err) {
      setmensagem(err.message);
      return [];
    }
  };

  const listaveiculos = async () => {
    try {
      const response = await api.get('v1/veiculos', { params });
      const lista = (response.data ?? []).map((item) => ({
        value: item.id,
        label: `${item.placa}${item.modelo ? ` - ${item.modelo}` : ''}`,
        empresaId: item.idempresa,
        pessoaId: item.idpessoa,
      }));
      return lista;
    } catch (err) {
      setmensagem(err.message);
      return [];
    }
  };

  const menuPortal = { menuPortal: (base) => ({ ...base, zIndex: 99999 }) };

  const listadespesas = async (veiculosArg) => {
    try {
      const response = await api.get('v1/despesasid', { params });
      const { data } = response;
      if (!data?.iddespesas) return;

      const id = data.iddespesas || ididentificador;
      if (s3Service && id) await listFilesFromS3(id);

      setIdmulta((data.idmulta || data?.categoria?.toLowerCase() === 'multas') ?? null);

      const source = Array.isArray(veiculosArg) && veiculosArg.length ? veiculosArg : veiculoslista;
      const veiculoSelecionado = source.find((item) => Number(item?.value) === Number(data.idveiculo));
      setselectedoptionveiculo(veiculoSelecionado ? { value: veiculoSelecionado.value, label: veiculoSelecionado.label } : null);

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
      setCategoriaDespesa((data.idmulta ? 'Multas' : data.categoria) || '');
      setidpessoa(data.idpessoa);
      setmensagem('');

      if (data.idempresa) {
        await listafuncionario(data.idempresa);
        setselectedoptionempresa({ value: data.idempresa, label: data.empresa });
      }

      if (data.idpessoa && data.funcionario) {
        setselectedoptionfuncionario({ value: data.idpessoa, label: data.funcionario });
      }

      if (data.idprojeto) { setSelectedProjeto(projetos.find((p) => String(p.value) === String(data.id))); }

      let depsSelections = [];
      let sitesSelections = [];
      let rateioFromApi = [];

      if (Array.isArray(data.rateio) && data.rateio.length > 0) {
        depsSelections = data.rateio
          .filter((r) => r.tipo === 'DEPARTAMENTO' && (r.departamento || r.iddepartamento))
          .map((r) => {
            const dep = r.departamento ?? r.iddepartamento;
            return { value: `DEP:${dep}`, label: dep };
          });

        const uniques = new Set(
          data.rateio.filter((r) => r.tipo === 'SITE' && r.idsite).map((r) => r.idsite)
        );
        sitesSelections = Array.from(uniques).map((s) => ({ value: `SITE:${s}`, label: `SITE-${s}` }));

        rateioFromApi = data.rateio
          .map((r) => {
            if (r.tipo === 'DEPARTAMENTO' && (r.departamento || r.iddepartamento)) {
              const dep = r.departamento ?? r.iddepartamento;
              return {
                key: `DEP:${dep}`,
                tipo: 'DEPARTAMENTO',
                iddepartamento: dep,
                idsite: null,
                label: dep,
                percentual: String(r.percentual ?? ''),
              };
            }
            if (r.tipo === 'SITE' && r.idsite) {
              const siteId = r.idsite;
              return {
                key: `SITE:${siteId}`,
                tipo: 'SITE',
                iddepartamento: null,
                idsite: siteId,
                label: `SITE-${siteId}`,
                percentual: String(r.percentual ?? ''),
              };
            }
            return null;
          })
          .filter(Boolean);
      }

      setAlocacoesSelecionadas(depsSelections);
      setSitesOptions(sitesSelections);
      setRateioItens(rateioFromApi);

      if (data.idprojeto && projetoOptions.length) {
        const opt = projetoOptions.find((o) => String(o.value) === String(data.idprojeto));
        if (opt) setSelectedProjeto(opt);
      }
    } catch (err) {
      setmensagem(err.message || 'Erro inesperado ao buscar despesas.');
    }
  };

  useEffect(() => {
    mountedRef.current = true;
    const init = async () => {
      setloading(true);
      setmensagem('');
      try {
        await fetchS3Credentials();

        const [empresas, veiculos] = await Promise.all([listaempresa(), listaveiculos()]);
        await listaDespesasFrota();
        await listaDespesasDepartamento();

        if (!mountedRef.current) return;

        setempresalista(empresas);
        setveiculoslista(veiculos);

        if (selectedLancarDespesas) {
          const veiculoSelecionado = veiculos.find((item) => Number(item?.value) === Number(selectedLancarDespesas.id));
          setselectedoptionveiculo(veiculoSelecionado ? { value: veiculoSelecionado.value, label: veiculoSelecionado.label } : null);
          setidveiculo(veiculoSelecionado?.value ?? null);

          if (selectedLancarDespesas.idempresa) {
            const empId = selectedLancarDespesas.idempresa;
            await listafuncionario(empId);
            const empresa = empresas.find((item) => Number(item?.value) === Number(empId));
            setselectedoptionempresa(empresa ? { value: empresa.value, label: empresa.label } : null);
            setidempresa(empId);
          }
        }

        await listadespesas(veiculos);
      } finally {
        if (mountedRef.current) setloading(false);
      }
    };
    init();
    return () => {
      mountedRef.current = false;
    };
  }, []);

  useEffect(() => {
    if (!selectedProjeto && projetoOptions.length && iddespesas) {
      (async () => {
        try {
          const { data } = await api.get('v1/despesasid', { params });
          if (data?.idprojeto) {
            const opt = projetoOptions.find((o) => String(o.value) === String(data.idprojeto));
            if (opt) setSelectedProjeto(opt);
          }
        } catch {
          console.log('Erro ao buscar despesa para reconciliar projeto');
        }
      })();
    }
  }, [projetoOptions]);

  // Seleciona "Frota" como projeto padrão em novos lançamentos
  useEffect(() => {
    if (!iddespesas && !selectedProjeto && projetoOptions.length) {
      const frotaOption = projetoOptions.find(
        (p) => String(p.label).toLowerCase() === 'frota'
      );
      if (frotaOption) {
        setSelectedProjeto(frotaOption);
      }
    }
  }, [iddespesas, selectedProjeto, projetoOptions]);

  useEffect(() => {
    if (idempresa && empresalista && empresalista.length > 0) {
      const empresaSelecionada = empresalista.find((e) => e.value === idempresa);
      setselectedoptionempresa(empresaSelecionada || null);
    }
  }, [idempresa, empresalista]);

  useEffect(() => {
    if (idpessoa && funcionariolista && funcionariolista.length > 0) {
      const funcionarioSelecionado =
        funcionariolista.find((f) => f.value === idpessoa || f.id === idpessoa || f.idpessoa === idpessoa) || null;
      if (funcionarioSelecionado) {
        setselectedoptionfuncionario({
          value: funcionarioSelecionado.value ?? funcionarioSelecionado.id ?? funcionarioSelecionado.idpessoa,
          label: funcionarioSelecionado.label ?? funcionarioSelecionado.nome ?? funcionarioSelecionado.descricao ?? '',
        });
      }
    }
  }, [funcionariolista, idpessoa]);

  const togglecadastro = () => setshow(false);

  const validarCampos = () => {
    if (!datalancamento) {
      setdatalancamento(new Date().toISOString().split('T')[0]);
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
      if (Number(parceladoEm) < 2) {
        setmensagem('O número de parcelas deve ser 2 ou mais.');
        return false;
      }
    }

    const totalItensRateio = (alocacoesSelecionadas?.length || 0) + (sitesOptions?.length || 0);

    if (categoriaDespesa === 'Multas') {
      if (!isEditing) {
        setmensagem('Multas não pode ser criada normalmente. Salve a despesa e edite a partir de um lançamento de multa.');
        return false;
      }
      if (totalItensRateio !== 1) {
        setmensagem('Para a categoria Multas, selecione exatamente um departamento OU informe exatamente um site.');
        return false;
      }
    } else if (totalItensRateio === 0) {
      setmensagem('Adicione pelo menos um departamento ou um site ao rateio.');
      return false;
    }

    const soma = rateioItens.reduce((acc, cur) => {
      const v = parseFloat(String(cur.percentual).replace(',', '.')) || 0;
      return acc + v;
    }, 0);
    const arred = Math.round(soma * 100) / 100;

    if (arred !== 100 && !(categoriaDespesa === 'Multas' || isFromMulta)) {
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
    const dataNow = new Date().toISOString().split('T')[0];

    if (!validarCampos()) return;

    if (periodicidade !== 'Unica') {
      const totalParcelas = Math.round(Number(parceladoEm) * Number(String(valordaparcela).replace(',', '.')) * 100) / 100;
      const totalInformado = Math.round(Number(String(valordespesa).replace(',', '.')) * 100) / 100;
      if (totalInformado !== totalParcelas) {
        setmensagem('Valor da parcela multiplicado pelo número de parcelas não é igual ao valor total.');
        return;
      }
    }

    setmensagem('');
    setmensagemsucesso('');
    setloading(true);

    const idProjetoAtual = selectedProjeto?.value ?? null;

    const payloadRateio = rateioItens.map((r) => ({
      tipo: r.tipo,
      iddepartamento: r.tipo === 'DEPARTAMENTO' ? r.iddepartamento : null,
      idsite: r.tipo === 'SITE' ? r.idsite : null,
      percentual: categoriaDespesa === 'Multas' || isFromMulta ? 100 : parseFloat(String(r.percentual).replace(',', '.')) || 0,
      idprojeto: idProjetoAtual,
    }));

    const payload = {
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
      categoria: isFromMulta ? 'Multas' : categoriaDespesa,
      periodicidade,
      idempresa,
      idpessoa,
      idmulta,
      idprojeto: idProjetoAtual,
      rateio: payloadRateio,
      despesacadastradapor: localStorage.getItem('sessionNome'),
      idcliente: 1,
      idusuario: 1,
      idloja: 1,
    };

    api
      .post('v1/despesas', payload)
      .then(async (response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          if (atualiza) atualiza();
          if (s3Service && (ididentificador || iddespesas)) {
            const id = ididentificador || iddespesas;
            await listFilesFromS3(id);
          }
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response?.data?.erro) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
      })
      .finally(() => {
        if (mountedRef.current) setloading(false);
      });
  }

  const handlefuncionario = (stat) => {
    if (stat !== null) {
      setidpessoa(stat.value);
      setselectedoptionfuncionario({ value: stat.value, label: stat.label });
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario(null);
    }
  };

  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
      listafuncionario(stat.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa(null);
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
    if (file && (ididentificador || iddespesas)) {
      try {
        const id = ididentificador || iddespesas;
        const key = `despesas/${id}/${file.name}`;
        await s3Service.uploadFile(file, key);
        const url = await s3Service.getFileUrl(key);
        setUploadedFiles((prev) => [...prev, { name: file.name, url, key }]);
        await listFilesFromS3(id);
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
      const id = ididentificador || iddespesas;
      const key = `despesas/${id}/${fileName}`;
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

  const removeSiteOption = (value) => {
    setSitesOptions((prev) => prev.filter((s) => s.value !== value));
  };

  const onChangeAlocacoes = (vals) => {
    if (categoriaDespesa === 'Multas' || isFromMulta) {
      const last = Array.isArray(vals) && vals.length ? vals[vals.length - 1] : null;
      if (last) setSitesOptions([]);
      setAlocacoesSelecionadas(last ? [last] : []);
    } else {
      setAlocacoesSelecionadas(vals || []);
    }
  };

  useEffect(() => {
    setRateioItens((prev) => {
      const prevMap = new Map(prev.map((p) => [p.key, p]));
      let next = [];
      (alocacoesSelecionadas || []).forEach((opt) => {
        const val = String(opt.value);
        if (val.startsWith('DEP:')) {
          const depName = val.slice(4);
          const key = `DEP:${depName}`;
          const found = prevMap.get(key);
          next.push(
            found
              ? { ...found, tipo: 'DEPARTAMENTO', iddepartamento: depName, idsite: null, label: depName }
              : { key, tipo: 'DEPARTAMENTO', iddepartamento: depName, idsite: null, label: depName, percentual: '' }
          );
        }
      });
      (sitesOptions || []).forEach((opt) => {
        const val = String(opt.value);
        if (val.startsWith('SITE:')) {
          const siteId = val.slice(5);
          const key = `SITE:${siteId}`;
          const found = prevMap.get(key);
          next.push(
            found
              ? { ...found, tipo: 'SITE', idsite: siteId, iddepartamento: null, label: `SITE-${siteId}` }
              : { key, tipo: 'SITE', iddepartamento: null, idsite: siteId, label: `SITE-${siteId}`, percentual: '' }
          );
        }
      });
      if ((categoriaDespesa === 'Multas' || isFromMulta) && next.length) {
        const first = { ...next[0], percentual: '100' };
        next = [first];
      }
      return next;
    });
  }, [alocacoesSelecionadas, sitesOptions, categoriaDespesa, isFromMulta]);

  const somaPercentuais = useMemo(() => {
    if (categoriaDespesa === 'Multas' || isFromMulta) return 100;
    const soma = rateioItens.reduce((acc, cur) => acc + (parseFloat(String(cur.percentual).replace(',', '.')) || 0), 0);
    return Math.round(soma * 100) / 100;
  }, [rateioItens, categoriaDespesa, isFromMulta]);

  const handlePercentualChange = (key, value) => {
    if (categoriaDespesa === 'Multas' || isFromMulta) {
      setRateioItens((prev) => prev.map((i) => (i.key === key ? { ...i, percentual: '100' } : i)));
      setmensagem('');
      return;
    }
    setRateioItens((prev) => prev.map((i) => (i.key === key ? { ...i, percentual: value } : i)));
    setmensagem('');
  };

  const removerItemRateio = (key) => {
    if (key.startsWith('DEP:')) {
      setAlocacoesSelecionadas((prev) => prev.filter((o) => o.value !== key));
    }
    if (key.startsWith('SITE:')) {
      setSitesOptions((prev) => prev.filter((o) => o.value !== key));
    }
  };

  const onChangeCategoria = (e) => {
    const { value } = e.target;
    if (value === 'Multas' && !isEditing) {
      setmensagem('Multas não pode ser criado normalmente.');
      return;
    }
    if (isFromMulta) {
      setmensagem('Despesa vinculada a multa: a categoria é fixa em "Multas".');
      setCategoriaDespesa('Multas');
      return;
    }
    setCategoriaDespesa(value);
    if (value === 'Unica') {
      setParceladoEm('1');
      setvalordaparcela(valordespesa);
    }
    if (value === 'Multas') {
      if (sitesOptions.length > 1) {
        setSitesOptions((prev) => (prev.length ? [prev[prev.length - 1]] : []));
      }
      if (alocacoesSelecionadas.length > 1) {
        const last = alocacoesSelecionadas[alocacoesSelecionadas.length - 1];
        setAlocacoesSelecionadas(last ? [last] : []);
      }
    }
  };

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
                  onChange={handlefuncionario}
                  value={selectedoptionfuncionario}
                />
              </div>

              <Col md="3">
                <FormGroup>
                  Categoria
                  <Input
                    type="select"
                    onChange={onChangeCategoria}
                    value={categoriaDespesa}
                    disabled={isFromMulta}
                  >
                    <option value="">Selecione</option>
                    <option value="Combustível">COMBUSTÍVEL</option>
                    <option value="Locação">LOCAÇÃO</option>
                    <option value="Manutenção">MANUTENÇÃO</option>
                    <option value="Pedágio">PEDÁGIO</option>
                    <option value="Multas" disabled={!isEditing && !isFromMulta}>Multas</option>
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
                        const value = Number(e.target.value) * (parseFloat(String(valordaparcela).replace(',', '.')) || 0);
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
                  Departamentos
                  <div className="d-flex align-items-end gap-2 mb-2">
                    <div className="flex-grow-1">
                      <Select
                        inputId="alocacoes-select"
                        instanceId="alocacoes-select"
                        isMulti
                        isClearable
                        isSearchable
                        name="alocacoes"
                        options={departamentos.map((dep) => ({
                          value: `DEP:${dep.nome}`,
                          label: dep.nome,
                        }))}
                        placeholder="Selecione departamentos"
                        value={alocacoesSelecionadas}
                        onChange={onChangeAlocacoes}
                        components={{ MultiValue: CustomMultiValue }}
                        styles={multiStyles}
                      />
                    </div>
                  </div>

                  Projeto
                  <div className="d-flex align-items-end gap-2 mt-2">
                    <div className="flex-grow-1">
                      <Select
                        inputId="projeto-select"
                        instanceId="projeto-select"
                        isClearable
                        isSearchable
                        name="projeto"
                        options={projetoOptions}
                        placeholder="Selecione o projeto"
                        value={selectedProjeto}
                        onChange={setSelectedProjeto}
                      />
                    </div>
                  </div>

                  <div className="d-flex align-items-end gap-2 mt-2">
                    <div className="flex-grow-1">
                      Site
                      <AsyncSelect
                        inputId="site-select"
                        instanceId="site-select"
                        isClearable
                        isSearchable
                        isMulti
                        cacheOptions
                        defaultOptions
                        name="site"
                        loadOptions={loadSites}
                        placeholder="Selecione ou busque site(s)"
                        value={sitesOptions}
                        onChange={(opts) => {
                          const arr = Array.isArray(opts) ? opts : opts ? [opts] : [];
                          let normalized = arr.map((opt) => {
                            const value = String(opt.value).startsWith('SITE:') ? String(opt.value) : `SITE:${opt.value}`;
                            const label = opt.label.startsWith('SITE-') ? opt.label : `SITE-${opt.label}`;
                            return { value, label };
                          });
                          if (categoriaDespesa === 'Multas' || isFromMulta) {
                            normalized = normalized.slice(-1);
                            setAlocacoesSelecionadas([]);
                          }
                          setSitesOptions(normalized);
                        }}
                        menuPortalTarget={document.body}
                        styles={menuPortal}
                      />
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
                Rateio
                <table className="table table-white-bg" aria-labelledby="rateio-label">
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
                            value={categoriaDespesa === 'Multas' || isFromMulta ? '100' : item.percentual}
                            onChange={(e) => handlePercentualChange(item.key, e.target.value)}
                            placeholder="0"
                            disabled={categoriaDespesa === 'Multas' || isFromMulta}
                          />
                        </td>
                        <td>
                          <Button
                            color="danger"
                            onClick={() => removerItemRateio(item.key)}
                            disabled={(categoriaDespesa === 'Multas' || isFromMulta) && rateioItens.length <= 1}
                          >
                            Remover
                          </Button>
                        </td>
                      </tr>
                    ))}
                    {rateioItens.length > 0 && (
                      <tr>
                        <td colSpan={2} className="text-end">
                          <strong>Total</strong>
                        </td>
                        <td>
                          <strong>{(categoriaDespesa === 'Multas' || isFromMulta ? 100 : somaPercentuais).toFixed(2)}</strong>
                        </td>
                        <td></td>
                      </tr>
                    )}
                  </tbody>
                </table>
                {rateioItens.length > 0 && somaPercentuais !== 100 && !(categoriaDespesa === 'Multas' || isFromMulta) && (
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
                    <Button color="primary" onClick={handleFileUpload} className="ms-0" disabled={!(ididentificador || iddespesas)}>Upload</Button>
                  </div>
                  {!(ididentificador || iddespesas) && (
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
