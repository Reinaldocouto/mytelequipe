import React, { useState, useEffect } from 'react';
import {
    Button,
    FormGroup,
    Input,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
} from 'reactstrap';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

const Parcelaedicao = ({ setshow, show, ididentificador, atualiza }) => {

    const [mensagem, setMensagem] = useState('');
    const [mensagemsucesso, setMensagemsucesso] = useState('');
    const [loading, setLoading] = useState(false);
    const [idpedido, setidpedido] = useState('');
    const [parcela, setparcela] = useState('');
    const [dias, setdias] = useState('');
    const [vencimento, setvencimento] = useState('');
    const [valor, setvalor] = useState('');
    const [idformapagamento, setidformapagamento] = useState('');



    const togglecadastro = () => {
        setshow(!show);
    };

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0
    };

    //Funções
    const listaparcelaedicao = async () => {
        try {
            setLoading(true);
            await api.get('v1/parcelamentoid', { params })
                .then(response => {
                    setidpedido(response.data.idpedido);
                    setparcela(response.data.parcela);
                    setdias(response.data.dias);
                    setvencimento(response.data.vencimento);
                    setvalor(response.data.valor);
                    setidformapagamento(response.data.idformapagamento);
                    setMensagem('');
                })
        } catch (err) {
            setMensagem(err.message);
        } finally {
            setLoading(false);
        }
    }

    function ProcessaCadastro(e) {
        e.preventDefault();
        setMensagem('');
        setMensagemsucesso('');
        api.post('v1/parcelamento', {
            idpedido: ididentificador,
            parcela,
            dias,
            vencimento,
            valor,
            idformapagamento,
            idcliente: localStorage.getItem('sessionCodidcliente'),
            idusuario: localStorage.getItem('sessionId'),
            idloja: localStorage.getItem('sessionloja'),
        })
            .then(response => {
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
            .catch(err => {
                if (err.response) {
                    setMensagem(err.response.data.erro);
                } else {
                    setMensagem('Ocorreu um erro na requisição.');
                }
                setMensagemsucesso('');
            });
    }

    useEffect(() => listaparcelaedicao(), []);
    return (
        <Modal isOpen={show} toggle={togglecadastro.bind(null)} backdrop='static' keyboard={false} className='modal-dialog modal-dialog-centered modal-dialog-scrollable'>
            <ModalHeader toggle={togglecadastro.bind(null)} >Edição Parcelamento</ModalHeader>
            <ModalBody>
                {mensagem.length > 0 ? <div className="alert alert-danger mt-2" role="alert">{mensagem}</div> : null}
                {mensagemsucesso.length > 0 ? <div className="alert alert-success" role="alert">Registro Salvo</div> : null}
                {loading ? <Loader /> :
                    <FormGroup>
                        <div className="row g-3">
                        <Input type="hidden" onChange={(e) => setidpedido(e.target.value)} value={idpedido} />
                            <div className="col-sm-4">
                                Parcela
                                <Input type="text" onChange={(e) => setparcela(e.target.value)} value={parcela} placeholder="" disabled />
                            </div>
                            <div className="col-sm-4">
                                Dias
                                <Input type="text" onChange={(e) => setdias(e.target.value)} value={dias} placeholder="" />
                            </div>
                            <div className="col-sm-4">
                                Vencimento
                                <Input type="text" onChange={(e) => setvencimento(e.target.value)} value={vencimento} placeholder="" />
                            </div>
                            <div className="col-sm-4">
                                Valor
                                <Input type="text" onChange={(e) => setvalor(e.target.value)} value={valor} placeholder="" />
                            </div>
                            <div className="col-sm-5">
                                Forma de Pagamento
                                <Input type="text" onChange={(e) => setidformapagamento(e.target.value)} value={idformapagamento} placeholder="" />
                            </div>
                        </div>
                    </FormGroup>
                }
            </ModalBody>
            <ModalFooter>
                <Button color="success" onClick={ProcessaCadastro}>
                    Salvar
                </Button>
                <Button color="secondary" onClick={togglecadastro.bind(null)}>
                    Sair
                </Button>
            </ModalFooter>
        </Modal>
    );
};

Parcelaedicao.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    ididentificador: PropTypes.number,
    atualiza: PropTypes.node,
};

export default Parcelaedicao;