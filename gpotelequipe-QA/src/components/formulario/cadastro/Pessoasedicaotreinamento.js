import { useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Pessoasedicaotreinamento = ({ setshow, show, atualiza }) => {
  const [validade, setvalidade] = useState();
  const [treinamento, settreinamento] = useState();
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);

  const togglecadastro = () => {
    setshow(!show);
  };

  const Processacolaborador = () => {
    setloading(true);
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/cadastratreinamento', {
        validade,
        treinamento,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(false);
          atualiza();
        } else {
          setmensagem(response.status);
          setmensagemsucesso('');
        }
        setloading(false);
      })
      .catch((err) => {
        if (err.response) {
          setmensagem(err.response.data.erro);
        } else {
          setmensagem('Ocorreu um erro na requisição.');
        }
        setmensagemsucesso('');
        setloading(false);
      });
  };

  return (
    <Modal
      isOpen={show}
      toggle={togglecadastro.bind(null)}
      backdrop="static"
      keyboard={false}
      className="modal-dialog modal-xl modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro.bind(null)}>Editar Informações colaborador</ModalHeader>
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
          <>
            <div className="row g-3">
              <div className="col-sm-8">
                Treinamento/Exame
                <Input
                  type="text"
                  onChange={(e) => settreinamento(e.target.value)}
                  value={treinamento}
                />
              </div>
              <div className="col-sm-4">
                Tempo de Validade (em dias)
                <Input type="text" onChange={(e) => setvalidade(e.target.value)} value={validade} />
              </div>
            </div>
          </>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={Processacolaborador} disabled={modoVisualizador()}>
          Salvar
        </Button>
        <Button color="secondary" onClick={togglecadastro.bind(null)}>
          Sair
        </Button>
      </ModalFooter>
    </Modal>
  );
};
Pessoasedicaotreinamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  atualiza: PropTypes.node,
};
export default Pessoasedicaotreinamento;
