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
import 'react-toastify/dist/ReactToastify.css';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

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

const LancamentoDespesas = ({ show, setShow, atualiza }) => {
  // Estados dos campos de lançamento de despesas
  const [loading, setLoading] = useState(false);
  const [categoriaDespesa, setCategoriaDespesa] = useState('');
  const [selectedVeiculo, setSelectedVeiculo] = useState(null);
  const [veiculoList, setVeiculoList] = useState([]);
  const [periodo, setPeriodo] = useState('');
  const [periodicidade, setPeriodicidade] = useState('');
  const [valor, setValor] = useState('');
  const [dataLancamento, setDataLancamento] = useState('');
  const [disabledButton, setDisableButton] = useState(false);
  // Função para alternar o modal
  const toggleCadastro = () => {
    setShow(!show);
  };

  // Busca a lista de veículos para o campo Placa/Veículo
  const listaVeiculos = async () => {
    try {
      setLoading(true);
      // Altere o endpoint conforme sua API
      const response = await api.get('v1/veiculos/select');
      setVeiculoList(response.data);
    } catch (err) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Manipula a seleção de veículo
  const handleVeiculoChange = (option) => {
    setSelectedVeiculo(option);
  };

  // Processa o cadastro do lançamento de despesa
  const processaDespesa = async (e) => {
    e.preventDefault();
    setDisableButton(true);
    const data = {
      categoria: categoriaDespesa,
      idveiculo: selectedVeiculo ? selectedVeiculo.value : null,
      placaVeiculo: selectedVeiculo ? selectedVeiculo.label : '',
      periodo,
      periodicidade,
      valordespesa: valor,
      datalancamento: dataLancamento,
      idcliente: 1,
      idpessoa: 1,
      idloja: 1,
    };
    try {
      const response = await api.post('v1/despesas', data);
      if (response.status === 201) {
        toast.success('Despesa cadastrada com sucesso!');
        setTimeout(() => {
          setShow(!show);
        }, 1000);
        if (atualiza) {
          atualiza();
        }
      } else {
        toast.error(`Erro: ${response.status}`);
      }
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    }
  };

  useEffect(() => {
    listaVeiculos();
  }, []);

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggleCadastro}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-xl modal-fullscreen"
      >
        <ModalHeader toggle={toggleCadastro} style={{ backgroundColor: 'white' }}>
          Lançamento de Despesas
        </ModalHeader>
        <ModalBody style={{ backgroundColor: 'white' }}>
          {loading ? (
            <Loader />
          ) : (
            <div className="row g-3">
              <Col md="3">
                <FormGroup>
                  Categoria
                  <Input
                    type="select"
                    onChange={(e) => setCategoriaDespesa(e.target.value)}
                    value={categoriaDespesa}
                  >
                    <option value="">Selecione</option>
                    <option value="Combustível">COMBUSTÍVEL</option>
                    <option value="Manutenção">MANUTENÇÃO</option>
                    <option value="Pedágio">PEDÁGIO</option>
                    <option value="Outros">OUTROS</option>
                  </Input>
                </FormGroup>
              </Col>
              <div className="col-sm-4">
                Placa/Veículo
                <Select
                  isClearable
                  isSearchable
                  name="veiculo"
                  options={veiculoList}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleVeiculoChange}
                  value={selectedVeiculo}
                />
              </div>
              <Col md="3">
                <FormGroup>
                  Período
                  <Input
                    type="text"
                    onChange={(e) => setPeriodo(e.target.value)}
                    value={periodo}
                    placeholder="Ex: 01/2025"
                  />
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Periodicidade
                  <Input
                    type="select"
                    onChange={(e) => setPeriodicidade(e.target.value)}
                    value={periodicidade}
                  >
                    <option value="">Selecione</option>
                    <option value="Mensal">MENSAL</option>
                    <option value="Bimestral">BIMESTRAL</option>
                    <option value="Trimestral">TRIMESTRAL</option>
                    <option value="Anual">ANUAL</option>
                  </Input>
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Valor
                  <Input
                    type="number"
                    onChange={(e) => setValor(e.target.value)}
                    value={valor}
                    placeholder="0.00"
                  />
                </FormGroup>
              </Col>
              <Col md="3">
                <FormGroup>
                  Data Lançamento de Despesas
                  <Input
                    type="date"
                    onChange={(e) => setDataLancamento(e.target.value)}
                    value={dataLancamento}
                  />
                </FormGroup>
              </Col>
            </div>
          )}
        </ModalBody>
        <ModalFooter style={{ backgroundColor: 'white' }}>
          <Button disabled={disabledButton} color="success" onClick={processaDespesa}>
            Salvar
          </Button>
          <Button color="secondary" onClick={toggleCadastro}>
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
      />
    </>
  );
};

LancamentoDespesas.propTypes = {
  show: PropTypes.bool.isRequired,
  setShow: PropTypes.func.isRequired,
  atualiza: PropTypes.func,
};

export default LancamentoDespesas;
