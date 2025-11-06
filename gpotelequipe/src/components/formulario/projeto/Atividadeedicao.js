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
import { Select } from '@mui/material';
import PropTypes from 'prop-types';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

const Atividadeedicao = ({ setshow, show, ididentificador, atualiza }) => {

    const [mensagem, setmensagem] = useState('');
    const [mensagemsucesso, setmensagemsucesso] = useState('');
    const [loading, setloading] = useState(false);
    const [idposervico, setidposervico] = useState('');
    const [idcolaboradorclt, setidcolaboradorclt] = useState('');
    const [po, setpo] = useState('');
    const [escopo, setescopo] = useState('');
    const [dataexecucaoclt, setdataexecucaoclt] = useState('');
    const [totalhorasclt, settotalhorasclt] = useState('');
    const [observacaoclt, setobservacaoclt] = useState('');
    const [colaboradorcltlista, setcolaboradorcltlista] = useState([]);
    const [selectedoptionposervico, setselectedoptionposervico] = useState(null);
    const [selectedoptioncolaboradorclt, setselectedoptioncolaboradorclt] = useState(null);

    const togglecadastro = () => {
        setshow(!show);
    };

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idcategoriabusca: ididentificador,
        deletado: 0
    };

    const handleChangeposervico = (stat) => {
        if (stat !== null) {
            setidposervico(stat.value);
            setselectedoptionposervico({ value: stat.value, label: stat.label });
            setpo(stat.po);
            setescopo(stat.escopo);

        } else {
            setidposervico(0);
            setselectedoptionposervico({ value: null, label: null });

        }
    }

    const handleChangecolaboradorclt = (stat) => {
        if (stat !== null) {
            setidcolaboradorclt(stat.value);
            setselectedoptioncolaboradorclt({ value: stat.value, label: stat.label });
        } else {
            setidcolaboradorclt(0);
            setselectedoptioncolaboradorclt({ value: null, label: null });
        }
    }

    const listacolaboradorclt = async () => {
        try {
            setloading(true);
            await api.get('v1/projetoericsson/selectcolaboradorclt', { params })
                .then(response => {
                    setcolaboradorcltlista(response.data);
                    console.log(response.data)
                    setmensagem('');
                })
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    }



    function ProcessaCadastro(e) {
        e.preventDefault();
        setmensagem('');
        setmensagemsucesso('');
        api.post('v1/categoria', {
            numero: ididentificador,
            idposervico, //descrição serviços
            po,
            escopo,
            idcolaboradorclt, //colaborador
            dataexecucaoclt,
            observacaoclt,
            totalhorasclt,
            idcliente: localStorage.getItem('sessionCodidcliente'),
            idusuario: localStorage.getItem('sessionId'),
            idloja: localStorage.getItem('sessionloja'),
        })
            .then(response => {
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
            .catch(err => {
                if (err.response) {
                    setmensagem(err.response.data.erro);
                } else {
                    setmensagem('Ocorreu um erro na requisição.');
                }
                setmensagemsucesso('');
            });
    }


    useEffect(() => listacolaboradorclt(), []);
    return (
        <Modal isOpen={show} toggle={togglecadastro.bind(null)} backdrop='static' keyboard={false} className='modal-dialog modal-xl modal-dialog-scrollable'>
            <ModalHeader toggle={togglecadastro.bind(null)} >Alterar Atividade</ModalHeader>
            <ModalBody>
                {mensagem.length > 0 ? <div className="alert alert-danger mt-2" role="alert">{mensagem}</div> : null}
                {mensagemsucesso.length > 0 ? <div className="alert alert-success" role="alert"> Registro Salvo</div> : null}
                {loading ? <Loader /> :

                    <FormGroup>
                        <div className="row g-3">
                            <div className="col-sm-6">
                                Descrição Serviço
                                <Input type="hidden" onChange={(e) => setidposervico(e.target.value)} value={idposervico} name="poservico" />
                                <Select
                                    isClearable
                                    isSearchable
                                    name="poservico"
                                    //options={poservicolista} //
                                    placeholder='Selecione'
                                    isLoading={loading}
                                    onChange={handleChangeposervico} //
                                    value={selectedoptionposervico} //
                                />
                            </div>
                            <div className="col-sm-3">
                                PO
                                <Input type="text" onChange={(e) => setpo(e.target.value)} value={po} placeholder="" disabled />
                            </div>
                            <div className="col-sm-3">
                                Escopo
                                <Input type="text" onChange={(e) => setescopo(e.target.value)} value={escopo} placeholder="" disabled />
                            </div>
                        </div>

                        <br></br>
                        <hr />
                        <div className="row g-3">
                            <div className="col-sm-7">
                                Colaborador
                                <Input type="hidden" onChange={(e) => setidcolaboradorclt(e.target.value)} value={idcolaboradorclt} name="idcolaborador" />
                                <Select
                                    isClearable
                                    isSearchable
                                    name="colaborador"
                                    options={colaboradorcltlista}
                                    placeholder='Selecione'
                                    isLoading={loading}
                                    onChange={handleChangecolaboradorclt}
                                    value={selectedoptioncolaboradorclt}
                                />
                            </div>
                            <div className="col-sm-3">
                                Data Execução
                                <Input type="date" onChange={(e) => setdataexecucaoclt(e.target.value)} value={dataexecucaoclt} placeholder="" />
                            </div>
                            <div className="col-sm-2">
                                Total de Horas
                                <Input type="number" onChange={(e) => settotalhorasclt(e.target.value)} value={totalhorasclt} placeholder="" />
                            </div>
                            <div className="col-sm-12">
                                Observação
                                <Input type="textarea" onChange={(e) => setobservacaoclt(e.target.value)} value={observacaoclt} placeholder="" />
                            </div>
                        </div>
                        <br></br>
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
        </Modal >
    );
};

Atividadeedicao.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    //idcadcategoria: PropTypes.number,
    ididentificador: PropTypes.number,
    atualiza: PropTypes.node,
    //titulotopo: PropTypes.string
};

export default Atividadeedicao;