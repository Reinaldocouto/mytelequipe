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
import '../../textarea.css';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import { Loader } from 'react-feather';
import api from '../../../services/api';
import SaltPassword from '../../../services/md5';

function TabPanel(props) {
    const { children, value, index, ...other } = props;

    return (
        <div
            role="tabpanel"
            hidden={value !== index}
            id={`simple-tabpanel-${index}`}
            aria-labelledby={`simple-tab-${index}`}
            {...other}
        >
            {value === index && (
                <Box sx={{ p: 3 }}>
                    <Typography>{children}</Typography>
                </Box>
            )}
        </div>
    );
}

TabPanel.propTypes = {
    children: PropTypes.node,
    index: PropTypes.number.isRequired,
    value: PropTypes.number.isRequired,
};

function a11yProps(index) {
    return {
        id: `simple-tab-${index}`,
        'aria-controls': `simple-tabpanel-${index}`,
    };
}


const Alterarsenha = ({ setshow, show, ididentificador }) => {

    const [mensagem, setMensagem] = useState('');
    const [mensagemsucesso, setMensagemsucesso] = useState('');
    const [loading, setLoading] = useState(false);
    const [senha, setsenha] = useState('');
    const [email, setemail] = useState('');

    const togglecadastro = () => {
        setshow(!show);
    };

    const [value, setValue] = useState(0);
    const handleChange = (event, newValue) => {
        setValue(newValue);
    };

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idfuncionariosbusca: ididentificador,
        deletado: 0
    };

    //Funções
    const listafuncionarios = async () => {
        try {
            setLoading(true);
            await api.get('v1/usuarios/alterar', { params })
                .then(response => {
                    setemail(response.data.email);
                    setMensagem('');
                })
        } catch (err) {
            setMensagem(err.message);
        } finally {
            setLoading(false);
        }
    }


    function ProcessaCadastro(e) {
        if (senha.length > 0) {
            e.preventDefault();
            setMensagem('');
            setMensagemsucesso('');
            console.log(senha)
            api.post('v1/usuarios/alterasenha', {
                idusuario: ididentificador,
                senha1: SaltPassword(senha),
            })
                .then(response => {
                    if (response.status === 201) {
                        setMensagem('');
                        setMensagemsucesso('Registro Salvo');
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
        else {
            setMensagem('Erro ao alterar senha!');

        }
    }


    const iniciatabelas = () => {
        listafuncionarios()

    };

    useEffect(() => {
        iniciatabelas();
    }, []);

    return (
        <Modal isOpen={show} backdrop='static' keyboard={false} className='modal-dialog modal-lg modal-dialog-scrollable'>
            <ModalHeader >Alterar Senha</ModalHeader>
            <ModalBody style={{ backgroundColor: 'white' }}>
                {mensagem.length > 0 ? <div className="alert alert-danger mt-2" role="alert">{mensagem}</div> : null}
                {mensagemsucesso.length > 0 ? <div className="alert alert-success" role="alert">Registro Salvo</div> : null}
                {loading ? <Loader /> :
                    <Box sx={{ width: '100%' }}>
                        <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                            <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
                                <Tab label="Alterar Senha" {...a11yProps(0)} />
                            </Tabs>
                        </Box>

                        <TabPanel value={value} index={0}>
                            <FormGroup>
                                <div className="row g-3 mb-3">

                                    <b>Contato</b>
                                    <div className="col-sm-6">
                                        Email*
                                        <Input type="text" onChange={(e) => setemail(e.target.value)} value={email} placeholder="" disabled />
                                    </div>
                                    <div className="col-sm-6">
                                        Senha
                                        <Input type="password" onChange={(e) => setsenha(e.target.value)} value={senha} placeholder="" />
                                    </div>
                                </div>
                            </FormGroup>

                        </TabPanel>
                    </Box>


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

Alterarsenha.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    ididentificador: PropTypes.number,
};

export default Alterarsenha;