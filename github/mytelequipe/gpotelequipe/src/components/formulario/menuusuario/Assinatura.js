import React, { useEffect, useState } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Assinaturaver from './Assinaturaver';

const Assinatura = ({ setshow, show }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [nome, setnome] = useState('');
  const [cargo, setcargo] = useState('');
  const [telefone, settelefone] = useState('');
  const [celular, setcelular] = useState('');
  const [email, setemail] = useState('');
  const [site, setsite] = useState('');
  const [endereco, setendereco] = useState('');
  const [telacadastro, settelacadastro] = useState('');

  const toggle = () => {
    setshow(!show);
  };

  const params = {
    idcliente: 1, //localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: 1, //localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const mostraassinatura = async () => {
    try {
      setloading(true);
      await api.get('v1/usuarios/assinatura', { params }).then((response) => {
        setnome(response.data.nome);
        setcargo(response.data.cargo);
        settelefone(response.data.telefone);
        setcelular(response.data.celular);
        setemail(response.data.email);
        setsite(response.data.site);
        setendereco(response.data.endereco);

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
    api
      .post('v1/usuarios/assinatura', {
        idusuario: localStorage.getItem('sessionId'),
        nome,
        cargo,
        telefone,
        celular,
        email,
        site,
        endereco,
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
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

  function assinaturaver() {
    settelacadastro(true);
  }

  const iniciatabelas = () => {
    mostraassinatura();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);
  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle.bind(null)}
        backdrop="static"
        className="modal-dialog modal-dialog-centered"
      >
        <ModalHeader>Assinatura</ModalHeader>
        <ModalBody>
          {telacadastro ? (
            <>
              {' '}
              <Assinaturaver show={telacadastro} setshow={settelacadastro} />{' '}
            </>
          ) : null}
          {mensagemsucesso.length > 0 ? (
            <div className="alert alert-success" role="alert">
              {' '}
              Registro Salvo
            </div>
          ) : null}
          {mensagem.length > 0 ? (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          ) : null}
          {loading ? (
            <Loader />
          ) : (
            <>
              <div className="row g-3">
                <div className=" col-sm-12 ">
                  <Input
                    type="text"
                    placeholder="Nome"
                    onChange={(e) => setnome(e.target.value)}
                    value={nome}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="Cargo"
                    onChange={(e) => setcargo(e.target.value)}
                    value={cargo}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="Telefone"
                    onChange={(e) => settelefone(e.target.value)}
                    value={telefone}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="Celular"
                    onChange={(e) => setcelular(e.target.value)}
                    value={celular}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="E-mail"
                    onChange={(e) => setemail(e.target.value)}
                    value={email}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="Site"
                    onChange={(e) => setsite(e.target.value)}
                    value={site}
                  />
                  <br />
                  <Input
                    type="text"
                    placeholder="Endereco"
                    onChange={(e) => setendereco(e.target.value)}
                    value={endereco}
                  />
                </div>
              </div>
            </>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="primary" onClick={assinaturaver}>
            Visualizar Assinatura
          </Button>
          <Button color="success" onClick={ProcessaCadastro}>
            Salvar
          </Button>
          <Button color="secondary" onClick={toggle.bind(null)}>
            Fechar
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Assinatura.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
};

export default Assinatura;
