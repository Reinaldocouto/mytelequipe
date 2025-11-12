import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Button, Input, Modal, ModalBody, ModalHeader, ModalFooter } from 'reactstrap';
import {
    DataGrid,
    GridActionsCellItem,
    gridPageCountSelector,
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay,
    ptBR,
} from '@mui/x-data-grid';
import Pagination from '@mui/material/Pagination';
import { Box } from '@mui/material';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import DeleteIcon from '@mui/icons-material/Delete';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import Mensagemsimples from '../../Mensagemsimples';
import Mensagemescolha from '../../Mensagemescolha';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Extratofechamentozte = ({ setshow, show, empresa, mespg, email, regional, idempresalocal }) => {
    const [mensagem, setmensagem] = useState('');
    const [extrato, setextrato] = useState([]);
    const [mensagemmostrardel, setmensagemmostrardel] = useState('');
    const [extratototal, setextratototal] = useState('');
    //  const [desconto, setdesconto] = useState(0);
    //  const [extratototalcdesc, setextratototalcdesc] = useState(0);
    //const [subvalor, setsubvalor] = useState(0);
    //    const [valorpago, setvalorpago] = useState('');
    const [loading, setloading] = useState(false);
    const [pageSize, setPageSize] = useState(12);
    const [emailadcional, setemailadcional] = useState('anna.christina@telequipeprojetos.com.br  ; ingrid.santos@telequipeprojetos.com.br ; juliana.yamaguchi@telequipeprojetos.com.br ; financeiro@telequipeprojetos.com.br ');
    const [emailpj, setemailpj] = useState('');
    const [mostra, setmostra] = useState('');
    const [motivo, setmotivo] = useState('');
    const [mensagemtela, setmensagemtela] = useState('');
    const [id, setid] = useState('');
    const [observacao, setobservacao] = useState('');

    //Parametros
    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        empresalocal: empresa,
        idempresa: idempresalocal,
        idempresabusca: idempresalocal,
        mespagamento: mespg
    };

    const toggle = () => {
        setshow(!show);
    };

    const lista = async () => {
        try {
            setloading(true);
            await api.get('v1/projetozteid/extrato', { params }).then((response) => {
                setextrato(response.data);
                setmensagem('');
            });
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };
    const listaempresa = async () => {
        try {
            setloading(true);
            await api.get('v1/empresasid', { params }).then((response) => {
                setemailpj(response.data.email);
                setmensagem('');
            });
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };






    const listatotal = async () => {
        try {
            setloading(true);
            await api.get('v1/projetozteid/extratototal', { params }).then((response) => {
                setextratototal(response.data.total);
                //setsubvalor(response.data.totalsimples);    
                //listadesconto(response.data.totalsimples);
                setmensagem('');
            });
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };


    function apagar(idextrato) {  //correigir e colocar o numero pra não excluir coisa errada
        setmensagemmostrardel(true);
        setid(idextrato);
    }

    const apagarpagamento = () => {
        setmensagem('');
        api
            .post('v1/projetozteid/fechamento/apagapagamento', {
                id
            })
            .then((response) => {
                if (response.status === 201) {
                    setmostra(true);
                    setmotivo(1);
                    setmensagemtela('Pagamento Excluido');
                    lista();
                    listatotal();
                    //         listadesconto();
                } else {
                    setmostra(true);
                    setmotivo(2);
                    setmensagemtela('Erro excluir pagamento!');
                }
            })
            .catch((err) => {
                console.log(err);
                if (err.response) {
                    setmensagem(err.response);
                } else {
                    setmensagem('Ocorreu um erro na requisição.');
                }
            });
    };


    function confirmacaodel(resposta) {
        setmensagemmostrardel(false);
        if (resposta === 1) {
            apagarpagamento();
        }
    }

    //tabela de itens
    const columns = [
        //{ field: 'id', headerName: 'ID', width: 80, align: 'center', },
        {
            field: 'actions',
            headerName: 'Ação',
            type: 'actions',
            width: 80,
            align: 'center',
            getActions: (parametros) => [
                <GridActionsCellItem
                    icon={<DeleteIcon />}
                    label="Apagar"
                    onClick={() =>
                        apagar(parametros.id)
                    }
                />,
            ],
        },
        {
            field: 'state',
            headerName: 'STATE',
            width: 100,
            align: 'left',
            editable: false,
        },
        {
            field: 'os',
            headerName: 'OS',
            width: 100,
            align: 'left',
            editable: false,
          },
        {
            field: 'siteid',
            headerName: 'ID SITE',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'sitename',
            headerName: 'SITENAME(DE)',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'sitenamefrom',
            headerName: 'SITENAME(PARA)',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'ztecode',
            headerName: 'ZTECODE',
            width: 160,
            align: 'left',
            editable: false,
        },
        {
            field: 'servicedescription',
            headerName: 'SERVICE DESCRIPTION',
            width: 350,
            align: 'left',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'qty',
            headerName: 'QTY',
            width: 100,
            align: 'left',
            editable: false,
        },
        {
            field: 'statusdoc',
            headerName: 'STATUS DOC',
            width: 100,
            align: 'left',
            editable: false,
        },
        {
            field: 'docresp',
            headerName: 'RESPONSAVEL DOC',
            width: 180,
            align: 'left',
            editable: false,
        },
        {
            field: 'porcentagem',
            headerName: 'PORCENTAGEM',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'valorpago',
            headerName: 'VALOR PAGO',
            width: 150,
            align: 'left',
            editable: false,
        },
        {
            field: 'fechamento',
            headerName: 'FECHAMENTO',
            width: 150,
            align: 'left',
            editable: false,
        },
    ];

    function CustomPagination() {
        const apiRef = useGridApiContext();
        const page = useGridSelector(apiRef, gridPageSelector);
        const pageCount = useGridSelector(apiRef, gridPageCountSelector);

        return (
            <Pagination
                color="secondary"
                count={pageCount}
                page={page + 1}
                onChange={(event, value) => apiRef.current.setPage(value - 1)}
            />
        );
    }

    function CustomNoRowsOverlay() {
        return (
            <GridOverlay>
                <div>Nenhum dado encontrado.</div>
            </GridOverlay>
        );
    }

    const enviaremail = () => {
        setmensagem('');
        console.log(emailpj);
        api
            .post('v1/email/acionamentopj/extratozte', {
                destinatario: emailadcional,
                destinatario1: emailpj,
                assunto: 'FECHAMENTO COSMX',
                mespg,
                empresa,
                regiona: regional,
                observacao,
                numero: idempresalocal,
                idusuario: localStorage.getItem('sessionId'),
            })
            .then((response) => {
                if (response.status === 200) {
                    setmostra(true);
                    setmotivo(1);
                    setmensagemtela('Email Enviando com Sucesso!');
                } else {
                    setmostra(true);
                    setmotivo(2);
                    setmensagemtela('Erro ao enviar a mensagem!');
                }
            })
            .catch((err) => {
                console.log(err);
                if (err.response) {
                    setmensagem(err.response);
                } else {
                    setmensagem('Ocorreu um erro na requisição.');
                }
            });
    };

    const gerarexcel = () => {
        const excelData = extrato.map((item) => {
            console.log(item);
            return {
                PO: item.po,
                POITEM: item.poitem,
                Sigla: item.sigla,
                IDSydle: item.idsydle,
                Cliente: item.cliente,
                Estado: item.estado,
                Codigo: item.codigo,
                Descricao: item.descricao,
                Mespagamento: item.mespagamento,
                Porcentagem: item.porcentagem,
                Valorpagamento: item.valorpagamento,
                Observacao: item.observacao,
            };
        });
        exportExcel({ excelData, fileName: 'extrato' });
    };

    const iniciatabelas = () => {
        lista();
        listatotal();
        listaempresa();

    };

    useEffect(() => {
        iniciatabelas();
        setemailpj(email)
    }, []);
    return (
        <Modal
            isOpen={show}
            toggle={toggle.bind(null)}
            backdrop="static"
            keyboard={false}
            className="modal-dialog modal-fullscreen modal-dialog-scrollable"
        >
            <ModalHeader toggle={toggle.bind(null)}>Extrato de Pagamento Cosmx</ModalHeader>
            <ModalBody>
                {mensagem.length > 0 ? (
                    <div className="alert alert-danger mt-2" role="alert">
                        {mensagem}
                    </div>
                ) : null}
                {mostra ? (
                    <>
                        {' '}
                        <Mensagemsimples
                            show={mostra}
                            setshow={setmostra}
                            mensagem={mensagemtela}
                            motivo={motivo}
                            titulo="Enviar E-mail de Acionamento"
                        />{' '}
                    </>
                ) : null}
                {mensagemmostrardel && (
                    <>
                        {' '}
                        <Mensagemescolha
                            show={mensagemmostrardel}
                            setshow={setmensagemmostrardel}
                            titulotopo="Excluir"
                            mensagem="Deseja realmente excluir esse pagamento?"
                            respostapergunta={confirmacaodel}
                        />{' '}
                    </>
                )}
                {loading ? (
                    <Loader />
                ) : (
                    <>
                        <Button color="link" onClick={() => gerarexcel()}>
                            Exportar Excel
                        </Button>
                        <div className="row g-3">
                            <div className="col-sm-6">
                                Empresa
                                <Input type="text" value={empresa} disabled />
                            </div>
                            <div className="col-sm-3">
                                Ano/Mês
                                <Input type="text" value={mespg} disabled />
                            </div>
                        </div>
                        <br />
                        <Box sx={{ height: 460, width: '100%' }}>
                            <DataGrid
                                rows={extrato}
                                columns={columns}
                                loading={loading}
                                pageSize={pageSize}
                                onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                disableSelectionOnClick
                                experimentalFeatures={{ newEditingApi: true }}
                                components={{
                                    Pagination: CustomPagination,
                                    LoadingOverlay: LinearProgress,
                                    NoRowsOverlay: CustomNoRowsOverlay,
                                }}
                                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                            />
                        </Box>

                        <br />
                        <div className=" col-sm-12 d-flex flex-row-reverse">
                            <div className="col-sm-2">
                                Valor a Total
                                <Input type="text" value={extratototal} disabled />
                            </div>
                        </div>
                        <br />
                        <div className="col-sm-12">
                            E-mails PJ
                            <Input
                                type="text"
                                onChange={(e) => setemailpj(e.target.value)}
                                value={emailpj}
                                placeholder="email pj"
                            />
                        </div>
                        <br />
                        <div className="col-sm-12">
                            E-mails adicionais
                            <Input
                                type="text"
                                onChange={(e) => setemailadcional(e.target.value)}
                                value={emailadcional}
                                placeholder="Digite os e-mails separados por virgula"
                            />
                        </div>
                        <br />
                        <div className="col-sm-12">
                            Mensagem E-mail
                            <Input
                                type="textarea"
                                onChange={(e) => setobservacao(e.target.value)}
                                value={observacao}
                                placeholder="Corpo do email"
                            />
                        </div>
                        <br />
                        <br />
                    </>
                )}
            </ModalBody>
            <ModalFooter>
                <Button color="secondary" onClick={enviaremail}>
                    Enviar E-mail <Icon.Mail />
                </Button>
                <Button color="secondary">
                    Imprimir <Icon.Printer />
                </Button>
                <Button color="secondary" onClick={toggle.bind(null)}>
                    Sair <Icon.LogOut />
                </Button>
            </ModalFooter>
        </Modal>
    );
};
Extratofechamentozte.propTypes = {
    mespg: PropTypes.string,
    empresa: PropTypes.string,
    setshow: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    email: PropTypes.string,
    regional: PropTypes.string,
    idempresalocal: PropTypes.string,
};

export default Extratofechamentozte;
