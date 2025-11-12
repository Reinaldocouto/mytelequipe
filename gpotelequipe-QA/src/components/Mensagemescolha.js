import React from 'react';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter
} from 'reactstrap';
import PropTypes from 'prop-types';

const Mensagemescolha = ({ setshow, show, mensagem, titulotopo, respostapergunta }) => {

    const togglemensagemsim = () => {
        respostapergunta(1);
        setshow(!show);
    }

    const togglemensagemnao = () => {
        respostapergunta(0);        
        setshow(!show);
    }


    return (
        <>
            <Modal isOpen={show} className='modal-dialog modal-dialog-centered'>
                <ModalHeader >{titulotopo}</ModalHeader>
                <ModalBody>
                    {mensagem}
                </ModalBody>
                <ModalFooter>
                    <Button color="primary" onClick={togglemensagemsim.bind(null)}>
                        SIM
                    </Button>
                    <Button color="primary" onClick={togglemensagemnao.bind(null)}>
                        NÃO
                    </Button>
                </ModalFooter>
            </Modal>

        </>

    );

}

Mensagemescolha.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    mensagem: PropTypes.node.isRequired,
    titulotopo:  PropTypes.string,
    respostapergunta: PropTypes.node,
};
export default Mensagemescolha;