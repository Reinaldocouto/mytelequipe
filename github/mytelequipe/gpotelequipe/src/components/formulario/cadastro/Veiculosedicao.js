import { useState, useEffect } from 'react';
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
import CreatableSelect from 'react-select/creatable';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Excluirregistro from '../../Excluirregistro';
import LancamentoDespesas from './Lancamentodespesas';

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

const Veiculosedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setmensagem] = useState('');
  const [loading, setloading] = useState(false);
  const [telaexclusao, settelaexclusao] = useState('');
  const [idveiculo, setidveiculo] = useState();
  const [inspecaoVeicular, setInspecaoVeicular] = useState();
  const [modelo, setmodelo] = useState();
  const [placa, setplaca] = useState();
  const [cor, setcor] = useState();
  const [categoria, setcategoria] = useState();
  const [iniciolocacao, setiniciolocacao] = useState('');
  const [fimlocacao, setfimlocacao] = useState('');
  const [periodicidade, setPeriodicidade] = useState('');
  const [ultimarevper, setultimarevper] = useState();
  const [kmsrestante, setkmsrestante] = useState();
  const [kmatual, setkmatual] = useState();
  const [km4, setkm4] = useState(); // km4 é o km de realização da última revisão periódica
  const [proximarevper, setproximarevper] = useState();
  const [marca, setmarca] = useState();
  const [fabricacao, setfabricacao] = useState();
  const [renavam, setrenavam] = useState();
  const [chassi, setchassi] = useState();
  const [idempresa, setidempresa] = useState('');
  const [idpessoa, setidpessoa] = useState('');
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);
  const [empresalista, setempresalista] = useState('');
  const [funcionariolista, setfuncionariolista] = useState('');
  const [licenciamento, setlicenciamento] = useState();
  const [mesbase, setmesbase] = useState();
  const [status, setstatus] = useState('');
  const [veiculoslista, setveiculoslista] = useState([]);
  const [placaError, setPlacaError] = useState('');

  // Estados para lançamento de despesas
  const [telalancamentodespesas, setTelalancamentodespesas] = useState(false);
  const [idDespesa, setIdDespesa] = useState(null);
  const [tituloDespesa, setTituloDespesa] = useState('');

  //Parametros
  const params = {
    idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
    idusuario: 1, //localStorage.getItem('sessionId'),
    idloja: 1, //localStorage.getItem('sessionloja'),
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  const formatDateBRToISO = (dateStr) => {
    if (!dateStr) return '';
    if (dateStr.includes('/')) {
      const [day, month, year] = dateStr.split('/');
      return `${year}-${month}-${day}`;
    }
    if (dateStr.includes('-')) {
      return dateStr;
    }
    return '';
  };
  const listaveiculos = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/veiculos', { params });
      //console.log("get de veiculos: ", response.data);
      const lista = response.data.map((item) => {
        return {
          value: item.placa,
          label: item.placa,
          empresaId: item.idempresa,
          pessoaId: item.idpessoa,
        };
      });
      setveiculoslista(lista);
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };
  const carregarDados = async () => {
    try {
      setloading(true);
      await api.get('v1/veiculosid', { params }).then((response) => {
        console.log('v1/veiculosid: ', response.data);
        setidveiculo(response.data.idveiculo);
        setInspecaoVeicular(response.data.inspecaoveicular);
        setmodelo(response.data.modelo);
        setplaca(response.data.placa);
        setcor(response.data.cor);
        setcategoria(response.data.categoria);
        setultimarevper(response.data.ultimarevper);
        setkmsrestante(response.data.kmsrestante);
        setkmatual(response.data.kmatual);
        setkm4(response.data.km4);
        setproximarevper(response.data.proximarevper);
        setmarca(response.data.marca);
        setfabricacao(response.data.fabricacao);
        setrenavam(response.data.renavam);
        setchassi(response.data.chassi);
        setlicenciamento(response.data.licenciamento);
        setmesbase(response.data.mesbase);
        setstatus(response.data.status);
        setidempresa(response.data.idempresa);
        setidpessoa(response.data.idpessoa);
        setiniciolocacao(response.data.iniciolocacao);
        setfimlocacao(response.data.fimlocacao);
        setPeriodicidade(response.data.periodicidade);
        setselectedoptionempresa({ value: response.data.idempresa, label: response.data.empresa });
        setselectedoptionfuncionario({
          value: response.data.idpessoa,
          label: response.data.funcionario,
        });
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const carregarDadosDoVeiculos = async (placaParams) => {
    try {
      setloading(true);
      const paramsWithPlaca = {
        ...params,
        placa: placaParams,
      };
      await api.get('v1/veiculoplaca', { params: paramsWithPlaca }).then((response) => {
        console.log('v1/veiculoplaca: ', response.data);
        setidveiculo(response.data.idveiculo);
        setInspecaoVeicular(response.data.inspecaoveicular);
        setmodelo(response.data.modelo);
        setplaca(response.data.placa);
        setcor(response.data.cor);
        setcategoria(response.data.categoria);
        setultimarevper(response.data.ultimarevper);
        setkmsrestante(response.data.kmsrestante);
        setkmatual(response.data.kmatual);
        setkm4(response.data.km4);
        setproximarevper(response.data.proximarevper);
        setmarca(response.data.marca);
        setfabricacao(response.data.fabricacao);
        setrenavam(response.data.renavam);
        setchassi(response.data.chassi);
        setlicenciamento(response.data.licenciamento);
        setmesbase(response.data.mesbase);
        setstatus(response.data.status);
        setidempresa(response.data.idempresa);
        setidpessoa(response.data.idpessoa);
        setiniciolocacao(response.data.iniciolocacao);
        setfimlocacao(response.data.fimlocacao);
        setPeriodicidade(response.data.periodicidade);
        setselectedoptionempresa({ value: response.data.idempresa, label: response.data.empresa });
        setselectedoptionfuncionario({
          value: response.data.idpessoa,
          label: response.data.funcionario,
        });
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      await api.get('v1/empresas/selectpj', { params }).then((response) => {
        setempresalista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listafuncionario = async (id) => {
    try {
      setloading(true);
      await api
        .get(`v1/pessoa/selectfuncionario/${id}`, {
          params: { isOnlyCnh: 1 },
        })
        .then((response) => {
          setfuncionariolista(response.data);
          setmensagem('');
        });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
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

  const handlefuncionario = (stat) => {
    if (stat !== null) {
      setidpessoa(stat.value);
      setselectedoptionfuncionario({ value: stat.value, label: stat.label });
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario({ value: null, label: null });
    }
  };

  const calcularRevisao = (kmAtualValue = kmatual, km4Value = km4) => {
    const proximaRevisao = parseInt(km4Value, 10) + 10000; // Próxima Revisão = KM 4 + 10.000 km
    setproximarevper(proximaRevisao);
    const restante = proximaRevisao - parseInt(kmAtualValue, 10); // KMs Restante = Próxima Revisão - KM Atual
    setkmsrestante(restante >= 0 ? restante : 0); // Caso o valor seja negativo, mostramos 0
  };

  const handleKmAtualChange = (e) => {
    const kmAtualValue = e.target.value;
    setkmatual(kmAtualValue);
    calcularRevisao(kmAtualValue);
  };

  const handleKm4Change = (e) => {
    const km4Value = e.target.value;
    setkm4(km4Value);
    calcularRevisao(undefined, km4Value);
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    const camposObrigatorios = {
      modelo: { value: modelo, label: 'Modelo' },
      placa: { value: placa, label: 'Placa' },
      cor: { value: cor, label: 'Cor' },
      categoria: { value: categoria, label: 'Categoria' },
      marca: { value: marca, label: 'Marca' },
      fabricacao: { value: fabricacao, label: 'Fabricação' },
      renavam: { value: renavam, label: 'Renavam' },
      chassi: { value: chassi, label: 'Chassi' },
      mesbase: { value: mesbase, label: 'Mês Base' },
      licenciamento: { value: licenciamento, label: 'Licenciamento' },
      status: { value: status, label: 'Status' },
      idempresa: { value: idempresa, label: 'Empresa' },
      idpessoa: { value: idpessoa, label: 'Funcionário' },
      kmatual: { value: kmatual, label: 'KM Atual' },
      inspecaoVeicular: { value: inspecaoVeicular, label: 'Inspeção Veicular' },
      ultimarevper: { value: ultimarevper, label: 'Ultima Revisão Periódica' },
    };

    const camposFaltantes = Object.values(camposObrigatorios)
      .filter(({ value }) => !value || value === '' || value === 'Selecione')
      .map(({ label }) => label);

    if (camposFaltantes.length > 0) {
      setmensagem(`Campos obrigatórios não preenchidos: ${camposFaltantes.join(', ')}`);
      return;
    }
    const data = {
      idveiculo: ididentificador,
      inspecaoVeicular,
      modelo,
      placa,
      cor,
      categoria,
      ...(iniciolocacao && { iniciolocacao: formatDateBRToISO(iniciolocacao) }),
      ...(fimlocacao && { fimlocacao: formatDateBRToISO(fimlocacao) }),
      periodicidade,
      ultimarevper,
      kmsrestante,
      kmatual,
      km4,
      proximarevper,
      marca,
      fabricacao,
      renavam,
      chassi,
      licenciamento,
      idempresa,
      idpessoa,
      mesbase,
      ativo: status,
      idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
      idusuario: 1, //localStorage.getItem('sessionId'),
      idloja: 1, //localStorage.getItem('sessionloja'),
    };

    console.log('Dados enviados:', JSON.stringify(data, null, 2));

    api
      .post('v1/veiculos', data)
      .then((response) => {
        if (response.status === 201) {
          setTimeout(() => {
            setshow(!show);
          }, 2000);
          atualiza();
          toast.success('Registro Salvo', {
            position: 'top-right',
            autoClose: 2000,
          });
          togglecadastro.bind(null);
        } else {
          toast.error(`Erro: ${response.status}`);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  }

  const novocadastroDespesa = () => {
    api
      .post('v1/despesas/novocadastro', {
        idcliente: 1,
        idusuario: 1,
        idloja: 1,
      })
      .then((response) => {
        if (response.status === 201) {
          setIdDespesa(response.data.retorno);
          setTituloDespesa('Cadastro de Despesas');
          setTelalancamentodespesas(true);
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
  const isValidLicensePlate = (plate) => {
    // Old Brazilian format (ABC-1234)
    const oldFormat = /^[A-Z]{3}[0-9]{4}$/;

    // Mercosul format (ABC1D23)
    const mercosulFormat = /^[A-Z]{3}[0-9]{1}[A-Z]{1}[0-9]{2}$/;

    // Remove any special characters and spaces
    const cleanPlate = plate.replace(/[^A-Za-z0-9]/g, '').toUpperCase();

    return oldFormat.test(cleanPlate) || mercosulFormat.test(cleanPlate);
  };
  const iniciatabelas = () => {
    setidveiculo(ididentificador);
    listaempresa();
    carregarDados();
    listaveiculos();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  return (
    <div style={{ position: 'relative' }}>
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
      <Modal
        isOpen={show}
        toggle={togglecadastro.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-xl modal-fullscreen  "
      >
        <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
          Cadastro de Veículos
        </ModalHeader>
        <ModalBody style={{ backgroundColor: 'white' }}>
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {/* Bloco de mensagem de sucesso removido em favor do toastify */}
          {telaexclusao ? (
            <>
              <Excluirregistro
                show={telaexclusao}
                setshow={settelaexclusao}
                ididentificador={ididentificador}
                quemchamou="PESSOAS"
              />{' '}
            </>
          ) : null}

          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="row g-3">
                <Col md="3">
                  Placa
                  <CreatableSelect
                    isClearable
                    isSearchable
                    name="veiculo"
                    options={veiculoslista}
                    placeholder="Selecione ou digite"
                    isLoading={loading}
                    onChange={(e) => {
                      setPlacaError(''); // Clear error on change

                      if (e) {
                        const placaSelecionada = e.value;
                        if (!veiculoslista.some((v) => v.value === placaSelecionada)) {
                          setveiculoslista([
                            ...veiculoslista,
                            { value: placaSelecionada, label: placaSelecionada },
                          ]);
                        }
                        setplaca(placaSelecionada);
                        carregarDadosDoVeiculos(placaSelecionada);
                      } else {
                        setplaca(null);
                      }
                    }}
                    onCreateOption={(inputValue) => {
                      const cleanInput = inputValue.replace(/[^A-Za-z0-9]/g, '').toUpperCase();
                      if (!isValidLicensePlate(cleanInput)) {
                        setPlacaError(
                          'Para criar uma nova placa, use o formato ABC-1234 ou ABC1D23',
                        );
                        return;
                      }
                      setPlacaError('');

                      const novaPlaca = { value: cleanInput, label: cleanInput };
                      setveiculoslista([...veiculoslista, novaPlaca]);
                      setplaca(cleanInput);
                    }}
                    value={placa ? { value: placa, label: placa } : null}
                  />
                  {placaError && (
                    <div style={{ color: 'red', fontSize: '12px', marginTop: '5px' }}>
                      {placaError}
                    </div>
                  )}
                </Col>

                <Col md="3">
                  <FormGroup>
                    <Input
                      type="hidden"
                      onChange={(e) => setidveiculo(e.target.value)}
                      value={idveiculo}
                      placeholder=""
                    />
                    Inspeção Veicular
                    <Input
                      type="date"
                      onChange={(e) => setInspecaoVeicular(e.target.value)}
                      value={inspecaoVeicular}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Modelo
                    <Input
                      type="text"
                      onChange={(e) => setmodelo(e.target.value)}
                      value={modelo}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Cor
                    <Input
                      type="text"
                      onChange={(e) => setcor(e.target.value)}
                      value={cor}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Marca
                    <Input
                      type="text"
                      onChange={(e) => setmarca(e.target.value)}
                      value={marca}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Fabricação
                    <Input
                      type="text"
                      onChange={(e) => setfabricacao(e.target.value)}
                      value={fabricacao}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="2">
                  <FormGroup>
                    Renavam
                    <Input
                      type="text"
                      onChange={(e) => setrenavam(e.target.value)}
                      value={renavam}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="2">
                  <FormGroup>
                    Mês Base
                    <Input
                      type="select"
                      onChange={(e) => setmesbase(e.target.value)}
                      value={mesbase}
                      placeholder=""
                    >
                      <option value="Selecione">Selecione</option>
                      <option value="Janeiro">Janeiro</option>
                      <option value="Fevereiro">Fevereiro</option>
                      <option value="Marco">Março</option>
                      <option value="Abril">Abril</option>
                      <option value="Maio">Maio</option>
                      <option value="Junho">Junho</option>
                      <option value="Julho">Julho</option>
                      <option value="Agosto">Agosto</option>
                      <option value="Setembro">Setembro</option>
                      <option value="Outubro">Outubro</option>
                      <option value="Novembro">Novembro</option>
                      <option value="Dezembro">Dezembro</option>
                    </Input>
                  </FormGroup>
                </Col>
                <Col md="2">
                  <FormGroup>
                    Licenciamento
                    <Input
                      type="number"
                      onChange={(e) => setlicenciamento(e.target.value)}
                      value={licenciamento}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Chassi
                    <Input
                      type="text"
                      onChange={(e) => setchassi(e.target.value)}
                      value={chassi}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="1">
                  <FormGroup>
                    Status
                    <Input
                      type="select"
                      onChange={(e) => setstatus(e.target.value)}
                      value={status}
                      name=""
                    >
                      <option value="Selecione">Selecione</option>
                      <option value="ATIVO">ATIVO</option>
                      <option value="INATIVO">INATIVO</option>
                    </Input>
                  </FormGroup>
                </Col>
                <div className="col-sm-4">
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
                <div className="col-sm-4">
                  Funcionário
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
              </div>
              <div className="row g-3">
                <div className="col-sm-4">
                  Categoria
                  <Input
                    type="select"
                    onChange={(e) => {
                      const selectedValue = e.target.value;
                      setcategoria(selectedValue);
                      // Condição removida para não resetar os campos de locação
                    }}
                    value={categoria}
                    name=""
                  >
                    <option value="">Selecione</option>
                    <option value="PROPRIO">PRÓPRIO</option>
                    <option value="PRESTADOR">PRESTADOR</option>
                    <option value="UNIDAS">UNIDAS</option>
                    <option value="MOVIDA">MOVIDA</option>
                    <option value="LOCALIZA">LOCALIZA</option>
                    <option value="OUTROS">OUTROS</option>
                  </Input>
                </div>
                <div className="col-sm-3">
                  Retirada
                  <Input
                    type="date"
                    onChange={(e) => setiniciolocacao(e.target.value)}
                    value={iniciolocacao}
                    placeholder=""
                  />
                </div>
                <div className="col-sm-3">
                  Devolução
                  <Input
                    type="date"
                    onChange={(e) => setfimlocacao(e.target.value)}
                    value={fimlocacao}
                    placeholder=""
                  />
                </div>
                <div className="col-sm-2">
                  <FormGroup>
                    Periodicidade
                    <Input
                      type="select"
                      onChange={(e) => setPeriodicidade(e.target.value)}
                      value={periodicidade}
                    >
                      <option value="">Selecione</option>
                      <option value="MENSAL">MENSAL</option>
                      <option value="PERIODICO">PERIODICO</option>
                    </Input>
                  </FormGroup>
                </div>

                <Col md="3">
                  <FormGroup>
                    KM Atual
                    <Input
                      type="text"
                      onChange={handleKmAtualChange}
                      value={kmatual}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Última Revisão Periódica
                    <Input
                      type="date"
                      onChange={(e) => setultimarevper(e.target.value)}
                      value={ultimarevper}
                      placeholder=""
                    />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    KM de realização
                    <Input type="text" onChange={handleKm4Change} value={km4} placeholder="" />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    Próxima Revisão Periódica
                    <Input type="text" value={proximarevper} placeholder="" disabled />
                  </FormGroup>
                </Col>
                <Col md="3">
                  <FormGroup>
                    KMs Restante
                    <Input type="text" value={kmsrestante} placeholder="" disabled />
                  </FormGroup>
                </Col>
              </div>
            </>
          )}
        </ModalBody>
        <ModalFooter style={{ backgroundColor: 'white' }}>
          <Button disabled={modoVisualizador()} color="primary" onClick={novocadastroDespesa}>
            Lançar Despesas
          </Button>
          <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
      {telalancamentodespesas ? (
        <LancamentoDespesas
          show={telalancamentodespesas}
          setShow={setTelalancamentodespesas}
          atualiza={atualiza}
          ididentificador={idDespesa}
          titulotopo={tituloDespesa}
        />
      ) : null}
    </div>
  );
};

Veiculosedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
};
export default Veiculosedicao;
