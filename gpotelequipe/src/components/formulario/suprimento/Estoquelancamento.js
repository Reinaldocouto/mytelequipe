import { useState, useEffect } from 'react';
import { Button, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Estoquelancamento = ({
  setshow,
  show,
  ididentificador,
  idprodutodetalhe,
  atualiza,
  titulotopo,
}) => {
  const [mensagem, setMensagem] = useState('');
  const [mensagemsucesso, setMensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [tipomovimentolista, settipomovimentolista] = useState([]);
  const [tipomovimento, settipomovimento] = useState(0);
  const [dataehora, setdataehora] = useState('');
  const [entrada, setentrada] = useState('');
  const [saida, setsaida] = useState('');
  const [balanco, setbalanco] = useState('');
  const [valor, setvalor] = useState('');
  const [observacao, setobservacao] = useState('');

  const togglecadastro = () => {
    setshow(!show);
  };

  //Parametros
  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    idcontroleestoquebusca: ididentificador,
    idprodutobusca: idprodutodetalhe,
    deletado: 0,
  };
  console.log(params);
  console.log(setloading);

  //Funções
  function ProcessaCadastro(e) {
    e.preventDefault();
    setMensagem('');
    setMensagemsucesso('');
    api
      .post('v1/controleestoquelancamento', {
        idcontroleestoque: ididentificador,
        idproduto: idprodutodetalhe,
        idtipomovimentacao: tipomovimento,
        dataehora,
        entrada,
        saida,
        valor,
        balanco,
        observacao,
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
      })
      .then((response) => {
        if (response.status === 201) {
          setMensagem('');
          setMensagemsucesso('Registro Salvo');
          setshow(!show);
          togglecadastro.bind(null);
          atualiza();
        } else {
          setMensagem(response.status);
          setMensagemsucesso('');
        }
      })
      .catch((err) => {
        if (err.response) {
          setMensagem(err.response.data.erro);
        } else {
          setMensagem('Ocorreu um erro na requisição.');
        }
        setMensagemsucesso('');
      });
  }

  const listatipomovimento = () => {
    api.get('v1/controleestoquelancamentotipo').then((response) => {
      settipomovimentolista(response.data);
    });
  };

  const iniciatabelas = () => {
    listatipomovimento();
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
      className="modal-dialog modal-dialog-centered  modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        {titulotopo}
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
          <>
            <div className="row g-3">
              <div className="col-sm-6">
                Tipo Movimento
                <Input
                  type="select"
                  onChange={(e) => settipomovimento(e.target.value)}
                  value={tipomovimento}
                >
                  <option>Selecione</option>
                  {tipomovimentolista.map((c) => {
                    return (
                      <option key={c.idtipomovimentacao} value={c.idtipomovimentacao}>
                        {c.tipomovimentacao}
                      </option>
                    );
                  })}
                </Input>
              </div>
              <div className="col-sm-6">
                Data e Hora
                <Input
                  type="datetime-local"
                  onChange={(e) => setdataehora(e.target.value)}
                  value={dataehora}
                  placeholder=""
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-4">
                Quantidade
                {tipomovimento === '1' ? (
                  <>
                    <Input
                      type="number"
                      onChange={(e) => setentrada(e.target.value)}
                      value={entrada}
                      placeholder=""
                    />
                  </>
                ) : (
                  <>
                    {tipomovimento === '2' ? (
                      <>
                        <Input
                          type="number"
                          onChange={(e) => setsaida(e.target.value)}
                          value={saida}
                          placeholder=""
                        />
                      </>
                    ) : (
                      <>
                        {tipomovimento === '3' ? (
                          <>
                            <Input
                              type="number"
                              onChange={(e) => setbalanco(e.target.value)}
                              value={balanco}
                              placeholder=""
                            />
                          </>
                        ) : (
                          <>
                            <Input type="number" placeholder="" disabled />
                          </>
                        )}
                      </>
                    )}
                  </>
                )}
              </div>
              <div className="col-sm-4">
                Preço Unitario
                <Input
                  type="number"
                  onChange={(e) => setvalor(e.target.value)}
                  value={valor}
                  placeholder=""
                />
              </div>
            </div>
            <br></br>
            <div className="row g-3">
              <div className="col-sm-12">
                Observação
                <Input
                  type="textarea"
                  onChange={(e) => setobservacao(e.target.value)}
                  value={observacao}
                  placeholder=""
                />
              </div>
            </div>
          </>
        )}
      </ModalBody>
      <ModalFooter style={{ backgroundColor: 'white' }}>
        <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};

Estoquelancamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  idprodutodetalhe: PropTypes.number,
  titulotopo: PropTypes.string,
  atualiza: PropTypes.node,
};

export default Estoquelancamento;
