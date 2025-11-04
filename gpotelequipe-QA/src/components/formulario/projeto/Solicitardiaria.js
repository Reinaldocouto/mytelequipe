import { useState, useEffect } from 'react';
import {
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  InputGroup,
} from 'reactstrap';
import { toast, ToastContainer } from 'react-toastify';
import PropTypes from 'prop-types';
import Select from 'react-select';
import { NumericFormat } from 'react-number-format';
import * as Icon from 'react-feather';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Mensagemescolha from '../../Mensagemescolha';
import Mensagemsimples from '../../Mensagemsimples';

const VALOR_DIARIA = 120;
const VALOR_DIARIA_FORMATADO = new Intl.NumberFormat('pt-BR', {
  style: 'currency',
  currency: 'BRL',
  minimumFractionDigits: 2,
}).format(VALOR_DIARIA);

const Solicitardiaria = ({
  setshow,
  show,
  ididentificador,
  atualiza,
  numero,
  projetousual,
  clientelocal,
  idlocal,
  sigla,
  regional: regionalProp = '',
}) => {
  function dataHojeISO() {
    return new Date().toISOString().split('T')[0];
  }

  function formatarDataBrasilComVerificacao(data) {
    if (!data) return '';
    const regexDataBR = /^\d{2}\/\d{2}\/\d{4}$/;
    if (typeof data === 'string' && regexDataBR.test(data.trim())) {
      return data.trim();
    }
    const dataObj = new Date(data);
    if (Number.isNaN(dataObj.getTime())) {
      return '';
    }
    return dataObj.toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    });
  }

  const [mensagemmostrar, setmensagemmostrar] = useState('');
  const [loading, setloading] = useState(false);
  const [idsolicitante, setidsolicitante] = useState('');
  const [solicitante, setsolicitante] = useState('');
  const [datasol, setdatasol] = useState(dataHojeISO());
  const [idcolaboradorclt, setidcolaboradorclt] = useState('');
  const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
  const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);
  const [idsolicitacao, setidsolicitacao] = useState('');
  const [titulomensagem, settitulomensagem] = useState('');
  const [mensagemdados, setmensagemdados] = useState('');
  const [telamensagem, settelamensagem] = useState('');
  const [projeto, setprojeto] = useState(projetousual);
  const [siteid, setsiteid] = useState(numero);
  const [siglasite, setsiglasite] = useState(sigla);
  const regionalValue = regionalProp || '';
  const [local, setlocal] = useState('');
  const [id, setid] = useState(idlocal);
  const [po, setpo] = useState('');
  const [descricao, setdescricao] = useState('');
  const [cliente, setcliente] = useState(clientelocal);
  const [valorsolicitacao, setvalorsolicitacao] = useState(0);
  const [diaria, setdiaria] = useState(0);
  const [total, settotal] = useState(0);

  const togglecadastro = () => {
    setshow(!show);
  };

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idnome: localStorage.getItem('sessionNome'),
    obra: numero,
    deletado: 0,
  };

  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/projetoericsson/selectcolaboradorclt', { params });
      setcolaboradorcltlista(response.data);
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  const resetForm = () => {
    setidcolaboradorclt('');
    setselectedoptioncolaboradorclt(null);
    setpo('');
    setlocal('');
    setdescricao('');
    setvalorsolicitacao(0);
    setdiaria(0);
    settotal(0);
    setdatasol(dataHojeISO());
  };

  function ProcessaCadastro() {
    const datasolicitacao = formatarDataBrasilComVerificacao(datasol);
    const colaborador = colaboradorcltlista.find((item) => item.value === idcolaboradorclt);
    if (!colaborador) {
      toast.error('Selecione um colaborador válido');
      return;
    }
    setloading(true);
    api
      .post('v1/solicitacao/editardiaria', {
        idsolicitacao,
        solicitante,
        datasol: datasolicitacao,
        idcolaboradorclt,
        nomecolaborador: colaborador.label,
        projeto,
        siteid,
        id,
        siglasite,
        regional: regionalValue || siglasite,
        po,
        local,
        descricao,
        cliente,
        valorsolicitacao,
        diaria,
        total,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          resetForm();
          if (typeof atualiza === 'function') {
            atualiza();
          }
        } else {
          toast.error(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      })
      .finally(() => {
        setloading(false);
      });
  }

  function limpacampos() { }

  const handleChangecolaboradorclt = (stat) => {
    if (stat !== null) {
      setidcolaboradorclt(stat.value);
      setselectedoptioncolaboradorclt({ value: stat.value, label: stat.label });
    } else {
      setidcolaboradorclt(0);
      setselectedoptioncolaboradorclt({ value: null, label: null });
    }
  };

  function confirmacao(resposta) {
    if (resposta === 1) {
      settitulomensagem('Sucesso');
      setmensagemdados('Sucesso');
      settelamensagem(true);
    }
  }

  const handleDiarias = (valor) => {
    const quantidade = Number(valor) || 0;
    const descricaoQuantidade = valor === '' ? '' : quantidade;
    setdiaria(valor);
    settotal(quantidade * VALOR_DIARIA + valorsolicitacao);
    setdescricao(`${descricaoQuantidade} Diárias ${VALOR_DIARIA_FORMATADO}`);
  };

  const iniciatabelas = () => {
    limpacampos();
    setidsolicitacao(ididentificador);
    setprojeto(projetousual);
    listacolaboradorclt();
    setsolicitante(localStorage.getItem('sessionNome') || '');
    setidsolicitante(localStorage.getItem('sessionId') || '');
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>Solicitação de Diária</ModalHeader>
      <ModalBody>
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
        {telamensagem && (
          <>
            <Mensagemsimples
              show={telamensagem}
              setshow={settelamensagem}
              mensagem={mensagemdados}
              titulo={titulomensagem}
            />
          </>
        )}
        {mensagemmostrar && (
          <>
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Confirmação"
              mensagem="O Parcelamento anterior será apagado. Deseja realmente editar o parcelamento? "
              respostapergunta={confirmacao}
            />
          </>
        )}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-1">
                Nº
                <Input type="text" value={idsolicitacao} placeholder="" disabled />
              </div>
              <div className="col-sm-3">
                Solicitante
                <InputGroup className="comprimento-group">
                  <Input type="hidden" value={idsolicitante} name="idsolicitante" />
                  <Input type="text" value={solicitante} name="status" disabled />
                </InputGroup>
              </div>

              <div className="col-sm-2">
                Dt Solicitação
                <Input type="date" onChange={(e) => setdatasol(e.target.value)} value={datasol} />
              </div>
              <div className="col-sm-4">
                Colaborador
                <Input
                  type="hidden"
                  onChange={(e) => setidcolaboradorclt(e.target.value)}
                  value={idcolaboradorclt}
                  name="idcolaborador"
                />
                <Select
                  isClearable
                  isSearchable
                  name="colaboradorclt"
                  options={colaboradorcltlista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleChangecolaboradorclt}
                  value={selectedoptioncolaboradorclt}
                />
              </div>
              <div className="col-sm-2">
                Projeto
                <Input
                  type="text"
                  onChange={(e) => setprojeto(e.target.value)}
                  value={projeto}
                  disabled
                />
              </div>
            </div>
            <br />

            <div className="row g-3">
              <div className="col-1">
                SITE ID
                <Input
                  type="text"
                  onChange={(e) => setsiteid(e.target.value)}
                  value={siteid}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-1">
                ID
                <Input
                  type="text"
                  onChange={(e) => setid(e.target.value)}
                  value={id}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-1">
                SIGLA SITE
                <Input
                  type="text"
                  onChange={(e) => setsiglasite(e.target.value)}
                  value={siglasite}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-2">
                PO
                <Input type="text" onChange={(e) => setpo(e.target.value)} value={po} placeholder="" />
              </div>

              <div className="col-4">
                LOCAL
                <Input
                  type="text"
                  onChange={(e) => setlocal(e.target.value)}
                  value={local}
                  placeholder=""
                />
              </div>

              <div className="col-sm-3">
                Descrição
                <Input
                  type="text"
                  onChange={(e) => setdescricao(e.target.value)}
                  value={descricao}
                  placeholder=""
                  disabled
                />
              </div>

              <div className="col-sm-2">
                Cliente
                <Input
                  type="text"
                  onChange={(e) => setcliente(e.target.value)}
                  value={cliente}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-sm-2">
                Valor Outras Solicitações
                <NumericFormat
                  value={valorsolicitacao}
                  onValueChange={(values) => {
                    const { floatValue = 0 } = values;
                    setvalorsolicitacao(floatValue);
                    const quantidade = Number(diaria) || 0;
                    settotal(quantidade * VALOR_DIARIA + floatValue);
                  }}
                  thousandSeparator="."
                  decimalSeparator=","
                  prefix="R$ "
                  decimalScale={2}
                  fixedDecimalScale
                  allowNegative={false}
                  customInput={Input}
                />
              </div>

              <div className="col-sm-2">
                Diarias
                <Input type="number" onChange={(e) => handleDiarias(e.target.value)} value={diaria} />
              </div>
              <div className="col-sm-3">
                Valor Total
                <NumericFormat
                  value={total}
                  onValueChange={(values) => {
                    const { floatValue } = values;
                    settotal(floatValue);
                  }}
                  thousandSeparator="."
                  decimalSeparator=","
                  prefix="R$ "
                  decimalScale={2}
                  fixedDecimalScale
                  allowNegative={false}
                  customInput={Input}
                  disabled
                />
              </div>
              <div className=" col-sm-3 d-flex flex-row-reverse">
                <Button color="primary" onClick={ProcessaCadastro} disabled={loading}>
                  Adicionar Solicitação <Icon.Plus />
                </Button>
              </div>
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Solicitardiaria.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  numero: PropTypes.string,
  projetousual: PropTypes.string,
  clientelocal: PropTypes.string,
  sigla: PropTypes.string,
  idlocal: PropTypes.string,
  regional: PropTypes.string,
};

export default Solicitardiaria;
