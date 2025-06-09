import { useState, useEffect } from 'react';
import { Button, FormGroup, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import Select from 'react-select';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Solicitacaoedicaoitens = ({
  setshow,
  show,
  ididentificador,
  idsolicitacoesitemlocal,
  atualiza,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [produtolista, setprodutolista] = useState([]);
  const [SelectedOptionProduto, setSelectedOptionProduto] = useState(null);
  const [idproduto, setidproduto] = useState('');
  const [codigosku, setcodigosku] = useState('');
  const [quantidade, setquantidade] = useState('');
  const [unidade, setunidade] = useState('');
  const [idsolicitacaoitens, setidsolicitacaoitens] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idsolicitacaoitensbusca: idsolicitacoesitemlocal,
    deletado: 0,
  };

  //descrição dos produtos
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

  //lista dos itens (id)
  const carregaitem = async () => {
    try {
      setloading(true);
      await api.get('v1/solicitacaoid/itens', { params }).then((response) => {
        setidsolicitacaoitens(response.data.idsolicitacaoitens);
        setquantidade(response.data.quantidade);
        setcodigosku(response.data.codigosku);
        setunidade(response.data.unidade);
        setidproduto(response.data.idproduto);
        setSelectedOptionProduto({
          value: response.data.idproduto,
          label: response.data.descricao,
        });
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  //salvar itens da solicitação
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
      .post('v1/solicitacao/editaritens', {
        idsolicitacaoitens: idsolicitacoesitemlocal,
        idsolicitacao: ididentificador,
        idproduto, //descrição
        quantidade,
        codigosku,
        unidade,

        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
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

  const handleChange = (stat) => {
    if (stat !== null) {
      setidproduto(stat.idproduto);
      setSelectedOptionProduto({ value: stat.value, label: stat.label });
      setcodigosku(stat.codigosku);
      setunidade(stat.unidade);
    } else {
      setidproduto(0);
      setSelectedOptionProduto({ value: null, label: null });
      setcodigosku(null);
      setunidade(null);
      //setprecounit(null); // colocar depois a logica de usar ou CUSTO ou CUSTOCOMPOSTO
    }
  };

  /*
  const multiplica = (qtd, valorunit) => {
    setquantidade(qtd);
    setprecounit(valorunit);
    setprecototal(formatToTwoDecimalPlaces(qtd * valorunit));
  }
*/

  function limpacampos() {
    setidproduto('');
    setcodigosku('');
    setquantidade('0.00');
    setunidade('');
  }

  const iniciatabelas = () => {
    setidsolicitacaoitens(idsolicitacoesitemlocal);
    console.log(idsolicitacoesitemlocal);
    limpacampos();
    carregaitem(); //listaitens
    listaproduto();
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
      <ModalHeader toggle={togglecadastro} style={{ backgroundColor: 'white' }}>
        Solicitação de Itens
      </ModalHeader>
      <ModalBody style={{ backgroundColor: 'white' }}>
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
              <Input
                type="hidden"
                onChange={(e) => setidsolicitacaoitens(e.target.value)}
                value={idsolicitacaoitens}
                placeholder=""
              />
              <div className="col-sm-12">
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
                  //onKeyDown={handleKeyUp}
                  value={SelectedOptionProduto}
                />
              </div>
            </div>
            <br></br>

            <div className="row g-3">
              <div className="col-sm-4">
                Qtde
                <Input
                  type="number"
                  onChange={(e) => setquantidade(e.target.value)}
                  value={quantidade}
                  placeholder=""
                />
              </div>
              <div className="col-sm-4">
                Código(SKU)
                <Input
                  type="text"
                  onChange={(e) => setcodigosku(e.target.value)}
                  value={codigosku}
                  placeholder=""
                  disabled
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
            </div>
          </FormGroup>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Adicionar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Solicitacaoedicaoitens.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  idsolicitacoesitemlocal: PropTypes.number,
  atualiza: PropTypes.node,
};

export default Solicitacaoedicaoitens;
