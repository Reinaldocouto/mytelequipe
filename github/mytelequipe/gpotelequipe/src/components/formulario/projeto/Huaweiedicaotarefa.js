import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input } from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import modoVisualizador from '../../../services/modovisualizador';

const Zteedicaotarefa = ({
  setshow,
  show,
  atualiza,
  titulotopo,
  regionlocal,
  sitenamelocal,
  siteidlocal,
  oslocal,
  projectnolocal,
  sitecodelocal,
}) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [projectno, setprojectno] = useState('');
  const [region, setregion] = useState('');
  const [os, setos] = useState('');
  const [sitename, setsitename] = useState('');
  const [siteid, setsiteid] = useState('');

  const [ponumber, setponumber] = useState('');
  const [itemcode, setitemcode] = useState('');
  const [itemdescription, setitemdescription] = useState('');
  const [qty, setqty] = useState('');
  const [sitecode, setsitecode] = useState('');
  const [vo, setvo] = useState('');

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');
    api
      .post('v1/projetohuawei/criartarefa', {
        projectno,
        region,
        os,
        sitename,
        siteid,
        ponumber,
        itemcode,
        itemdescription,
        qty,
        sitecode,
        vo,
        usaurio: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 201) {
          setmensagem('');
          setmensagemsucesso('Registro Salvo');
          setshow(!show);
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

  const togglecadastro = () => {
    setshow(!show);
  };

  const iniciatabelas = () => {
    setprojectno(projectnolocal);
    setregion(regionlocal);
    setos(oslocal);
    setsitename(sitenamelocal);
    setsiteid(siteidlocal);
    setsitecode(sitecodelocal);
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
      className="modal-dialog modal-xl modal-dialog-scrollable"
    >
      <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
        {titulotopo}{' '}
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
        <>
          <div className="row g-3">
            <div className="col-sm-2">
              <Input
                type="hidden"
                // onChange={(e) => setos(e.target.value)}
                value={os}
                placeholder="os"
              />
              Project No
              <Input
                type="text"
                // onChange={(e) => setprojectno(e.target.value)}
                value={projectno}
                disabled="true"
              />
            </div>
            <div className="col-sm-5">
              Site Name
              <Input
                type="text"
                // onChange={(e) => setsitename(e.target.value)}
                value={sitename}
                disabled="true"
              />
            </div>
            <div className="col-sm-3">
              Site ID
              <Input
                type="text"
                // onChange={(e) => setsiteid(e.target.value)}
                value={siteid}
                disabled="true"
              />
            </div>

            <div className="col-sm-2">
              Região
              <Input
                type="text"
                //   onChange={(e) => setregion(e.target.value)}
                value={region}
                disabled="true"
              />
            </div>
          </div>
          <br />

          <div className="row g-3">
            <div className="col-sm-2">
              PO Number
              <Input type="text" onChange={(e) => setponumber(e.target.value)} value={ponumber} />
            </div>
            <div className="col-sm-2">
              Item Code
              <Input type="text" onChange={(e) => setitemcode(e.target.value)} value={itemcode} />
            </div>
            <div className="col-sm-5">
              Item Description
              <Input
                type="text"
                onChange={(e) => setitemdescription(e.target.value)}
                value={itemdescription}
              />
            </div>

            <div className="col-sm-1">
              Qty
              <Input type="number" onChange={(e) => setqty(e.target.value)} value={qty} />
            </div>

            <div className="col-sm-2">
              VO
              <Input type="text" onChange={(e) => setvo(e.target.value)} value={vo} />
            </div>
          </div>
        </>
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

Zteedicaotarefa.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  atualiza: PropTypes.node,
  titulotopo: PropTypes.string,
  regionlocal: PropTypes.string,
  sitenamelocal: PropTypes.string,
  siteidlocal: PropTypes.string,
  oslocal: PropTypes.string,
  projectnolocal: PropTypes.string,
  sitecodelocal: PropTypes.string,
};

export default Zteedicaotarefa;
