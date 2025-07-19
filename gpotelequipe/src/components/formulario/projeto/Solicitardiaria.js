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
//import InfoIcon from '@mui/icons-material/Info';
import * as Icon from 'react-feather';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Mensagemescolha from '../../Mensagemescolha';
import Mensagemsimples from '../../Mensagemsimples';
//import Parcelas from '../parcelamento/Parcela';

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
}) => {
  function dataHojeISO() {
    return new Date().toISOString().split('T')[0];
  }
  function formatarDataBrasilComVerificacao(data) {
    if (!data) return '';

    // Já está no formato dd/MM/yyyy?
    const regexDataBR = /^\d{2}\/\d{2}\/\d{4}$/;
    if (typeof data === 'string' && regexDataBR.test(data.trim())) {
      return data.trim();
    }

    // Tenta converter para Date
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
  const [local, setlocal] = useState('');
  const [id, setid] = useState(idlocal);
  const [po, setpo] = useState('');
  const [descricao, setdescricao] = useState('');
  const [cliente, setcliente] = useState(clientelocal);
  const [valorsolicitacao, setvalorsolicitacao] = useState(0);
  const [diaria, setdiaria] = useState(0);
  const [total, settotal] = useState(0);

  /*
      const [nitens, setnitens] = useState(0);
      const [somaqtdes, setsomaqtdes] = useState(0);
      const [totalprodutos, settotalprodutos] = useState(0);
      const [desconto, setdesconto] = useState(0);
      const [frete, setfrete] = useState(0);
      const [totalipi, settotalipi] = useState(0);
      const [totalicmsst, settotalicmsst] = useState(0);
      const [totalgeral, settotalgeral] = useState(0);
      const [dataprevista, setdataprevista] = useState('');
      const [numerofornecedor, setnumerofornecedor] = useState(0);
      const [datacompra, setdatacompra] = useState('');
      const [idtransportadora, setidtransportadora] = useState('');
      const [idtipofrete, setidtipofrete] = useState('');
       */
  //const [observacao, setobservacao] = useState('');

  //const [numero, setnumero] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idnome: localStorage.getItem('sessionNome'), //localStorage.setItem('sessionNome', response.data.nome);
    obra: numero,
    deletado: 0,
  };

  //Funções
  const listacolaboradorclt = async () => {
    try {
      setloading(true);
      await api.get('v1/projetoericsson/selectcolaboradorclt', { params }).then((response) => {
        setcolaboradorcltlista(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  function ProcessaCadastro() {
    const datasolicitacao = formatarDataBrasilComVerificacao(datasol);
    const colaborador = colaboradorcltlista.find((item) => item.value === idcolaboradorclt);
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
          console.log(atualiza());
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
      });
  }

  function limpacampos() {
    //setnitens('0');
    // setsomaqtdes('0.00');
    // settotalprodutos('0.00');
    //setdesconto('0.00');
    //setfrete('0.00');
    //settotalipi('0.00');
    //settotalicmsst('0.00');
    //settotalgeral('0.00');
  }

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
    //  setmensagemmostrar(true);
    if (resposta === 1) {
      //  setverparcelas(false);
      // setcondicaopagamento('');
      // setdesabilita(false);
      settitulomensagem('Sucesso');
      setmensagemdados('Sucesso');
      settelamensagem(true);
    }
  }
  const handleDiarias = (valor) => {
    setdiaria(valor);
    settotal(valor * 100 + valorsolicitacao);
    setdescricao(`${valor} Diárias R$ 100,00`);
  };

  const iniciatabelas = () => {
    limpacampos();
    setidsolicitacao(ididentificador);
    setprojeto(projetousual);
    console.log(ididentificador);
    listacolaboradorclt();
    setsolicitante(localStorage.getItem('sessionNome'));
    setidsolicitante(localStorage.getItem('sessionId'));
  };
  console.log(setidsolicitante);

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
            {' '}
            <Mensagemsimples
              show={telamensagem}
              setshow={settelamensagem}
              mensagem={mensagemdados}
              titulo={titulomensagem}
            />{' '}
          </>
        )}
        {mensagemmostrar && (
          <>
            {' '}
            <Mensagemescolha
              show={mensagemmostrar}
              setshow={setmensagemmostrar}
              titulotopo="Confirmação"
              mensagem="O Parcelamento anterior será apagado. Deseja realmente editar o parcelamento? "
              respostapergunta={confirmacao}
            />{' '}
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
                <Input
                  type="text"
                  onChange={(e) => setpo(e.target.value)}
                  value={po}
                  placeholder=""
                />
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
                    const { floatValue } = values; // Aqui usamos const
                    setvalorsolicitacao(floatValue);
                    settotal(diaria * 100 + values.floatValue);
                  }}
                  thousandSeparator="."
                  decimalSeparator=","
                  prefix="R$ "
                  decimalScale={2}
                  fixedDecimalScale
                  allowNegative={false}
                  customInput={Input} // Mantém o estilo do Bootstrap
                />
              </div>

              <div className="col-sm-2">
                Diarias
                <Input
                  type="number"
                  onChange={(e) => handleDiarias(e.target.value)}
                  value={diaria}
                />
              </div>
              <div className="col-sm-3">
                Valor Total
                <NumericFormat
                  value={total}
                  onValueChange={(values) => {
                    const { floatValue } = values; // Aqui usamos const
                    settotal(floatValue);
                  }}
                  thousandSeparator="."
                  decimalSeparator=","
                  prefix="R$ "
                  decimalScale={2}
                  fixedDecimalScale
                  allowNegative={false}
                  customInput={Input} // Mantém o estilo do Bootstrap
                  disabled
                />
              </div>
              <div className=" col-sm-3 d-flex flex-row-reverse">
                <Button color="primary" onClick={ProcessaCadastro}>
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
};

export default Solicitardiaria;
