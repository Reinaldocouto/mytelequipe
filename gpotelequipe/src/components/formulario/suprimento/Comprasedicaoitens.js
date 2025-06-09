import React, { useState, useEffect, useRef } from 'react';
import { Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import Select from 'react-select';
import * as Icon from 'react-feather';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Produtosedicao from '../cadastro/Produtosedicao';

const Comprasedicaoitens = ({
  setshow,
  show,
  ididentificador,
  idordemcompralocal,
  atualiza,
  titulotopo,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [produtolista, setprodutolista] = useState([]);
  //const [ordemcompralista, setordemcompralista] = useState([]);
  const [SelectedOptionProduto, setSelectedOptionProduto] = useState(null);
  const [idproduto, setidproduto] = useState('');
  const [codigosku, setcodigosku] = useState('');
  const [quantidade, setquantidade] = useState('');
  const [unidade, setunidade] = useState('');
  const [precounit, setprecounit] = useState('');
  const [ipi, setipi] = useState('');
  const [valoricmsst, setvaloricmsst] = useState('');
  const [precototal, setprecototal] = useState('');
  const [telacadastroedicao, settelacadastroedicao] = useState('');
  const [titulo, settitulo] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idordemcompraitem: ididentificador,
    idordemcompra: idordemcompralocal,
    deletado: 0,
  };

  //Funções
  const inputRef1 = useRef(1);
  const inputRef2 = useRef(2);
  const inputRef3 = useRef(3);
  const inputRef4 = useRef(4);
  const inputRef5 = useRef(5);

  // Função para tratar o evento onKeyDown
  const handleKeyUp = (event) => {
    if (event.key === 'Enter') {
      console.log(event);
      console.log(inputRef2.current);

      if (event.target === inputRef1.current) {
        inputRef2.current.focus(); // Se pressionou Enter no primeiro input, foca no segundo input
      } else if (event.target === inputRef2.current && inputRef3.current) {
        event.preventDefault(); // Impede o comportamento padrão do "Enter" (submit do formulário, por exemplo)
        inputRef3.current.focus(); // Se pressionou Enter no primeiro input, foca no segundo input
      } else if (event.target === inputRef3.current) {
        inputRef4.current.focus(); // Se pressionou Enter no primeiro input, foca no segundo input
      } else if (event.target === inputRef4.current) {
        inputRef5.current.focus(); // Se pressionou Enter no primeiro input, foca no segundo input
      }
    }
  };

  const listaproduto = async () => {
    try {
      setloading(true);
      await api.get('v1/produto/select', { params }).then((response) => {
        setprodutolista(response.data);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const cadastraProduto = () => {
    //novo cadastro de produtos
    api
      .post('v1/produto/novocadastro', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setidproduto(response.data.retorno);
          settitulo('Novo Fornecedor');
          settelacadastroedicao(true);
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

  const carregaitem = async () => {
    try {
      setloading(true);
      await api.get('v1/ordemcompra/itensid', { params }).then((response) => {
        setidproduto(response.data.idproduto);
        setcodigosku(response.data.codigosku);
        setquantidade(response.data.quantidade);
        setunidade(response.data.unidade);
        setprecounit(response.data.preco);
        setipi(response.data.ipi);
        setvaloricmsst(response.data.valorst);
        setprecototal(response.data.valortotal);
        setSelectedOptionProduto({
          value: response.data.idordemcompraitens,
          label: response.data.produto,
        });
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');

    //verifica se o idproduto é válido
    if (!idproduto) {
      setmensagem('O campo Descrição é obrigatório');
      return; //sai da função se não tiver o idproduto
    }

    api
      .post('v1/ordemcompra/itens', {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idordemcompra: idordemcompralocal,
        idordemcompraitens: ididentificador,
        idproduto,
        qtd: quantidade,
        preco: precounit,
        ipi,
        valorst: valoricmsst,
        valortotal: precototal,
        //Intl.NumberFormat('pt-BR').format(
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
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
      });
  }

  const formatToTwoDecimalPlaces = (value) => {
    // Converte o valor para número (se já não for) e formata para duas casas decimais
    const formattedValue = parseFloat(value).toFixed(2);
    return formattedValue;
  };

  const handleChange = (stat) => {
    if (stat !== null) {
      setidproduto(stat.idproduto);
      setSelectedOptionProduto({ value: stat.value, label: stat.label });
      setcodigosku(stat.codigosku);
      setunidade(stat.unidade);
      setprecounit(stat.custo); // colocar depois a logica de usar ou CUSTO ou CUSTOCOMPOSTO
    } else {
      setidproduto(0);
      setSelectedOptionProduto({ value: null, label: null });
      setcodigosku(null);
      setunidade(null);
      setprecounit(null); // colocar depois a logica de usar ou CUSTO ou CUSTOCOMPOSTO
    }
  };

  const multiplica = (qtd, valorunit) => {
    setquantidade(qtd);
    setprecounit(valorunit);
    setprecototal(formatToTwoDecimalPlaces(qtd * valorunit));
  };

  function limpacampos() {
    setidproduto('');
    setcodigosku('');
    setquantidade('0.00');
    setunidade('');
    setprecounit('0.00');
    setipi('0.00');
    setvaloricmsst('0.00');
    setprecototal('0.00');
  }

  const iniciatabelas = () => {
    limpacampos();
    listaproduto();
    if (titulotopo === 'Alterar Item') {
      console.log('entrei carrega item');
      carregaitem();
    }
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro}>{titulotopo}</ModalHeader>
      <ModalBody>
        {mensagem.length > 0 ? (
          <div className="alert alert-danger mt-2" role="alert">
            {mensagem}
          </div>
        ) : null}
        {mensagemsucesso.length > 0 ? (
          <div className="alert alert-success" role="alert">
            {' '}
            Registro Salvo
          </div>
        ) : null}
        {loading ? (
          <Loader />
        ) : (
          <FormGroup>
            <div className="row g-3">
              <div className="col-sm-9">
                Descrição
                <Select
                  isClearable
                  //components={{ Control: ControlComponent }}
                  isSearchable
                  name="produto"
                  options={produtolista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleChange}
                  onKeyDown={handleKeyUp}
                  value={SelectedOptionProduto}
                  ref={inputRef1}
                />
              </div>
              <div className="col-sm-3">
                Codigo(SKU)
                <Input
                  type="text"
                  onChange={(e) => setcodigosku(e.target.value)}
                  value={codigosku}
                  placeholder=""
                  disabled
                />
              </div>
            </div>
            <br></br>

            <div className="row g-3">
              <div className="col-sm-4">
                Qtde
                <Input
                  ref={inputRef2}
                  type="number"
                  onChange={(e) => multiplica(e.target.value, precounit)}
                  value={quantidade}
                  onKeyDown={handleKeyUp}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Unidade
                <Input
                  type="text"
                  onChange={(e) => setunidade(e.target.value)}
                  value={unidade}
                  placeholder=""
                  disabled
                />
              </div>
              <div className="col-sm-4">
                Preço Unit.
                <Input
                  ref={inputRef3}
                  type="number"
                  onChange={(e) => multiplica(quantidade, e.target.value)}
                  value={precounit}
                  onKeyDown={handleKeyUp}
                  placeholder=""
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-4">
                IPI%
                <Input
                  ref={inputRef4}
                  type="number"
                  onChange={(e) => setipi(e.target.value)}
                  value={ipi}
                  onKeyDown={handleKeyUp}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Valor ICMS-ST
                <Input
                  ref={inputRef5}
                  type="number"
                  onChange={(e) => setvaloricmsst(e.target.value)}
                  value={valoricmsst}
                  onKeyDown={handleKeyUp}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Preço Total
                <Input
                  type="number"
                  onChange={(e) => setprecototal(e.target.value)}
                  value={precototal}
                  placeholder=""
                  disabled
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-12">
                <Button color="link">
                  <Icon.Search /> Busca Avançada de Itens
                </Button>
                <Button color="link" onClick={cadastraProduto}>
                  <Icon.PlusCircle /> Cadastra Produto
                </Button>
                {telacadastroedicao && (
                  <>
                    {' '}
                    <Produtosedicao
                      show={telacadastroedicao}
                      setshow={settelacadastroedicao}
                      ididentificador={idproduto}
                      titulotopo={titulo}
                      atualiza={idproduto}
                    />{' '}
                  </>
                )}
              </div>
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={ProcessaCadastro}>
          Adicionar
        </Button>
        {/** 
        <Button color="primary" onClick={ProcessaCadastro}>
          Adicionar e Continuar
        </Button>
        */}
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Comprasedicaoitens.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  idordemcompralocal: PropTypes.number,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
};

export default Comprasedicaoitens;
