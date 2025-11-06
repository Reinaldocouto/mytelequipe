import { useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';


const Pessoasedicaocontrato = ({ setshow, show, ididentificador, atualiza, funcionario }) => {
  const [contrato, setcontrato] = useState();
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);

  console.log(ididentificador);
  console.log(atualiza);
  const togglecadastro = () => {
    setshow(!show);
  };

  const Processacolaborador = () => {
    setloading(true);
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/empresas/colaborador', {
        ididentificador,
        contrato,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          atualiza();
          setshow(false);
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
      className="modal-dialog modal-xl modal-dialog-scrollable   "
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
          <div className="row g-3">
            <div className="col-sm-8">
              Colaborador
              <Input type="text" value={funcionario} disabled />
            </div>
            <div className="col-sm-4">
              Contrato
              <Input
                type="select"
                onChange={(e) => setcontrato(e.target.value)}
                value={contrato}
                name="Tipo Pessoa"
              >
                <option value="Selecione">Selecione</option>
                <option value="CONTRATO MEI RECEBIDO">CONTRATO MEI RECEBIDO</option>
                <option value="CONTRATO CLT RECEBIDO">CONTRATO CLT RECEBIDO</option>
                <option value="CONTRATO DE REPRESENTAÇÃO">CONTRATO DE REPRESENTAÇÃO</option>
                <option value="PENDENTE">PENDENTE</option>
              </Input>
            </div>
          </div>
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
Pessoasedicaocontrato.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.node,
  funcionario: PropTypes.string,
};
export default Pessoasedicaocontrato;
