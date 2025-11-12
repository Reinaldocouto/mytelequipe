import React from 'react';
import * as Icon from 'react-feather';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter
} from 'reactstrap';
import PropTypes from 'prop-types';

const Mensagemsimples = ({ setshow, show, mensagem, motivo, titulo }) => {

    const togglemensagem = () => {
        setshow(!show);
    }
    const tipomensagem = () => {

        switch (motivo) {
            case 1: return (<div><Icon.Check color = "black" size={48}/>{mensagem} </div>); // positiva
            case 2: return (<div><Icon.AlertTriangle  color = "red" size={48} />{mensagem} </div>);  // negativa
            default: return (null);
        }
    }

    return (
        <>
            <Modal isOpen={show} toggle={togglemensagem.bind(null)} className='modal-dialog modal-dialog-centered'>
                <ModalHeader toggle={togglemensagem.bind(null)} >{titulo}</ModalHeader>
                <ModalBody>
                    {tipomensagem()}
                </ModalBody>
                <ModalFooter>
                    <Button color="secondary" onClick={togglemensagem.bind(null)}>
                        Ok
                    </Button>
                </ModalFooter>
            </Modal>

        </>

    );

}

Mensagemsimples.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    mensagem: PropTypes.node.isRequired,
    motivo: PropTypes.number,
    titulo: PropTypes.string,
};
export default Mensagemsimples;