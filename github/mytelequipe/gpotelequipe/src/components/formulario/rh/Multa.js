import React, { useState } from 'react';
import {
    Button,
    Input,
    FormGroup,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import {
    DataGrid,
    gridPageCountSelector,
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay,
    ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
//import exportExcel from '../../../data/exportexcel/Excelexport';

const Multa = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(100);
    const [loading, setLoading] = useState(false);
    const [folhapagamento, setfolhapagamento] = useState([]);
    const [mensagem, setmensagem] = useState('');
    const [datapagamento, setdatapagamento] = useState('');

    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
        datafolha: datapagamento,
    };

    const listafolhapagamento = async () => {
        if (datapagamento.length > 0) {
            try {
                setLoading(true);
                console.log(params)
                await api.get('v1/rh/folhapagamento', { params }).then((response) => {
                    setfolhapagamento(response.data);
                    setmensagem('');
                });
            } catch (err) {
                setmensagem(err.message);
            } finally {
                setLoading(false);
            }
        } else { setmensagem('Falta selecionar o periodo de visualização') }
    };

    const columns = [
        // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        {
            field: 'codigo',
            headerName: 'Codigo',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'nome',
            headerName: 'Nome',
            width: 300,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'tipopessoa',
            headerName: 'Tipo Pessoa',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'dataadmissao',
            headerName: 'Data Admissao',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'cargo',
            headerName: 'Cargo',
            width: 200,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'cbo',
            headerName: 'CBO',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'pis',
            headerName: 'PIS',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'rgrne',
            headerName: 'RG/RNE',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'datanascimento',
            headerName: 'Data Nascimento',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'cpf',
            headerName: 'CPF',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'banco',
            headerName: 'Banco',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'agencia',
            headerName: 'Agência',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'containformada',
            headerName: 'Conta Informada',
            width: 180,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'salariobruto',
            headerName: 'salariobruto',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'salariobase',
            headerName: 'salariobase',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'salariofamilia',
            headerName: 'salariofamilia',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'outros',
            headerName: 'outros',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'horaextra',
            headerName: 'horaextra',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'adian40',
            headerName: 'adian40',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'adian6',
            headerName: 'adian6',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'portoseg',
            headerName: 'portoseg',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'inss',
            headerName: 'inss',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'irrf',
            headerName: 'irrf',
            width: 350,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'salarioliquido',
            headerName: 'salarioliquido',
            width: 350,
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


    /*    const gerarexcel = () => {
            const excelData = totalacionamento.map((item) => ({
                PO: item.po,
                "PO ITEM": item.poitem,
                Sigla: item.sigla,
                IDsydle: item.idsydle,
                NOME: item.nome,
                'cliente': item.cliente,
                'Estado': item.estado,
                'Codigo Serviço': item.codigo,
                'Descricao': item.descricao,
                'Mes Pagamento': item.mespagamento,
                'Numero': item.numero,
                'Porcentagem': item.porcentagem,
                'valor Pagamento': item.valorpagamento,
                'Observacao': item.observacao,
                'Empresa': item.empresa
            }));
            exportExcel({ excelData, fileName: 'Relatorio_Total_acionamento' });
        };*/
    return (
        <>
            <Modal
                isOpen={show}
                toggle={toggle}
                backdrop="static"
                keyboard={false}
                className="modal-dialog modal-fullscreen modal-dialog-scrollable"
            >
                <ModalHeader style={{ backgroundColor: 'white' }}>Folha de Pagamento</ModalHeader>
                <ModalBody style={{ backgroundColor: 'white' }}>
                    {mensagem.length > 0 ? (
                        <div className="alert alert-danger mt-2" role="alert">
                            {mensagem}
                        </div>
                    ) : null}
                    {loading ? (
                        <Loader />
                    ) : (
                        <>
                            <FormGroup>
                                <div className="row g-3">
                                    <div className="col-sm-2">
                                        <Input
                                            type="month"
                                            onChange={(e) => setdatapagamento(e.target.value)}
                                            value={datapagamento}
                                        />
                                    </div>
                                    <div className="col-sm-1">
                                        <Button color="primary" onClick={listafolhapagamento} >
                                            Visualizar
                                        </Button>
                                    </div>
                                    <div className="col-sm-2">
                                        <Button color="primary" >
                                            Nova Folha
                                        </Button>
                                    </div>
                                    <div className="col-sm-3">
                                        <Button color="primary" >
                                            Fechar Folha
                                        </Button>
                                    </div>

                                </div>
                            </FormGroup>


                            {/*   <Button color="link" onClick={gerarexcel}>
                                Exportar Excel
                            </Button> */}

                            <Box sx={{ height: '100%', width: '100%' }}>
                                <DataGrid
                                    rows={folhapagamento}
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
                <ModalFooter style={{ backgroundColor: 'white' }}>
                    <Button color="secondary" onClick={toggle}>
                        Fechar
                    </Button>
                </ModalFooter>
            </Modal>
        </>
    );
};

Multa.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Multa;
