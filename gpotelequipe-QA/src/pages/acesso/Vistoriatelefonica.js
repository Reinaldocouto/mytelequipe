import React, { useState, useEffect } from 'react';
import {
    Button,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
    DataGrid,
    gridPageCountSelector,
    GridActionsCellItem,
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay,
    ptBR,
} from '@mui/x-data-grid';
import EditIcon from '@mui/icons-material/Edit';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
//import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import Rollouttelefonicaedicao from '../../components/formulario/rollout/Rollouttelefonicaedicao';
import Excluirregistro from '../../components/Excluirregistro';

const Vistoriatelefonica = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [totalacionamento, settotalacionamento] = useState([]);
    const [mensagem, setmensagem] = useState('');
    const [ididentificador, setididentificador] = useState(0);
    const [telacadastroedicao, settelacadastroedicao] = useState('');
    const [telaexclusao, settelaexclusao] = useState('');
    const [telacadastro, settelacadastro] = useState('');
    const [titulo, settitulo] = useState('');

   /* const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
    }; */

    const listarollouttelefonica = async () => {
        try {
            setLoading(true);
            //const response = await api.get('v1/rollouttelefonica', { params });
            settotalacionamento(0);
            setmensagem('');
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setLoading(false);
        } 
    };

    function alterarUser(stat) {
        settitulo('Editar Rollout Telefonica');
        setididentificador(stat);
        settelacadastroedicao(true);

    }


    const columns = [
        {
            field: 'actions',
            headerName: 'Ação',
            type: 'actions',
            width: 80,
            align: 'center',
            getActions: (parametros) => [
                <GridActionsCellItem
                    icon={<EditIcon />}
                    label="Alterar"
                    hint="Alterar"
                    onClick={() => alterarUser(parametros.id)}
                />,
            ],
        },
        // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        {
            field: 'pmts',
            headerName: 'ID CPOM RF',
            width: 120,
            align: 'center',
            type: 'string',
            editable: false,
        },
        {
            field: 'sytex',
            headerName: 'UF',
            width: 130,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'pmoref',
            headerName: 'Sigla',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'pmocategoria',
            headerName: 'Status',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },

        {
            field: 'uididpmts',
            headerName: 'Requisição',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'ufsigla',
            headerName: 'T2',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'pmosigla',
            headerName: 'PEDIDO',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },

    ];

    function CustomNoRowsOverlay() {
        return (
            <GridOverlay>
                <div>Nenhum dado encontrado</div>
            </GridOverlay>
        );
    }
    function CustomPagination() {
        const apiRef = useGridApiContext();
        const page = useGridSelector(apiRef, gridPageSelector);
        const pageCount = useGridSelector(apiRef, gridPageCountSelector);

        return (
            <Pagination
                color="primary"
                count={pageCount}
                page={page + 1}
                onChange={(event, value) => apiRef.current.setPage(value - 1)}
            />
        );
    }

    const toggle = () => {
        setshow(!show);
    };

    const iniciatabelas = () => {
        listarollouttelefonica();
    };

    useEffect(() => {
        iniciatabelas();
    }, []);

    const gerarexcel = () => {
        const excelData = totalacionamento.map((item) => ({
            Numero: item.numero,
            Sigla: item.site,
            PO: item.po,
            "PO ITEM": item.poitem,
            NOME: item.nome,
            'CODIGO SERVIÇO': item.codigoservico,
            'DESCRIÇÃO SERVIÇO': item.descricaoservico,
            "VALOR SERVIÇO": item.valorservico,
            "LPU HISTÓRICO": item.lpuhistorico,
            "DATA ENVIO EMAIL": item.datadeenviodoemail ? new Date(item.datadeenviodoemail).toLocaleString('pt-BR', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
            }) : '',
        }));
        exportExcel({ excelData, fileName: 'Relatorio_Total_acionamento' });
    };

    return (
        <>
            <Modal
                isOpen={show}
                toggle={toggle}
                backdrop="static"
                keyboard={false}
                className="modal-dialog modal-fullscreen modal-dialog-scrollable"
            >
                <ModalHeader>Pedido Vistoria - Telefonica</ModalHeader>
                <ModalBody>
                    {mensagem.length > 0 ? (
                        <div className="alert alert-danger mt-2" role="alert">
                            {mensagem}
                        </div>
                    ) : null}
                    {loading ? (
                        <Loader />
                    ) : (
                        <>

                            {telacadastro ? (
                                <>
                                    {' '}
                                    <Rollouttelefonicaedicao
                                        show={telacadastro}
                                        setshow={settelacadastro}
                                        ididentificador={ididentificador}
                                        atualiza={listarollouttelefonica}
                                        titulotopo={titulo}
                                    />{' '}
                                </>
                            ) : null}
                            {telacadastroedicao ? (
                                <>
                                    {' '}
                                    <Rollouttelefonicaedicao
                                        show={telacadastroedicao}
                                        setshow={settelacadastroedicao}
                                        ididentificador={ididentificador}
                                        atualiza={listarollouttelefonica}
                                        titulotopo={titulo}
                                    />{' '}
                                </>
                            ) : null}

                            {telaexclusao ? (
                                <>
                                    <Excluirregistro
                                        show={telaexclusao}
                                        setshow={settelaexclusao}
                                        ididentificador={ididentificador}
                                        quemchamou="ROLLOUTTELEFONICA"
                                        atualiza={listarollouttelefonica}
                                    />{' '}
                                </>
                            ) : null}


                            <div className="row g-3">
                                <div className="col-sm-3">
                                    <Button color="link" onClick={gerarexcel}>
                                        Exportar Excel
                                    </Button>
                                </div>
                            </div>
                            <br />
                            <Box sx={{ height: '85%', width: '100%' }}>
                                <DataGrid
                                    rows={totalacionamento}
                                    columns={columns}
                                    loading={loading}
                                    pageSize={pageSize}
                                    onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
                                    disableSelectionOnClick
                                    components={{
                                        Pagination: CustomPagination,
                                        LoadingOverlay: LinearProgress,
                                        NoRowsOverlay: CustomNoRowsOverlay,
                                    }}

                                    localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                                />
                            </Box>
                        </>
                    )}
                </ModalBody>
                <ModalFooter>
                    <Button color="secondary" onClick={toggle}>
                        Fechar
                    </Button>
                </ModalFooter>
            </Modal>
        </>
    );
};

Vistoriatelefonica.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Vistoriatelefonica;
