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
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay,
    ptBR,
} from '@mui/x-data-grid';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import Loader from '../../layouts/loader/Loader';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';

const Rolloutzte = ({ setshow, show }) => {
    const [pageSize, setPageSize] = useState(10);
    const [loading, setLoading] = useState(false);
    const [totalacionamento, settotalacionamento] = useState([]);
    const [mensagem, setmensagem] = useState('');

    const params = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        deletado: 0,
    };

    const listarolloutzte = async () => {
        try {
            setLoading(true);
            const response = await api.get('v1/rolloutzte', { params });
            settotalacionamento(response.data);
            setmensagem('');
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setLoading(false);
        }
    };

    const columns = [
        // { field: 'id', headerName: 'ID', width: 80, align: 'center' },
        {
            field: 'sitename',
            headerName: 'SITENAME',
            width: 130,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'sitenamefrom',
            headerName: 'SITENAMEFROM',
            width: 130,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'uf',
            headerName: 'UF',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'regiao',
            headerName: 'REGIAO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'cidade',
            headerName: 'CIDADE',
            width: 300,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'endereco',
            headerName: 'ENDERECO',
            width: 500,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'lat',
            headerName: 'LAT',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'long',
            headerName: 'LONG',
            width: 120,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statuszte',
            headerName: 'STATUSZTE',
            width: 200,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'projeto',
            headerName: 'PROJETO',
            width: 150,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'supervisorzte',
            headerName: 'SUPERVISORZTE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'empresa',
            headerName: 'EMPRESA',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'modelobateria',
            headerName: 'MODELOBATERIA',
            width: 300,
            align: 'left',
            type: 'string',
            editable: false,
            renderCell: (parametros) => <div style={{ whiteSpace: 'pre-wrap' }}>{parametros.value}</div>,
        },
        {
            field: 'qtybat',
            headerName: 'QTYBAT',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'concentrador',
            headerName: 'CONCENTRADOR',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'acesso',
            headerName: 'ACESSO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'tiposite',
            headerName: 'TIPOSITE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'instalplan',
            headerName: 'INSTALPLAN',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'instalreal',
            headerName: 'INSTALREAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statusprojetoint',
            headerName: 'STATUSPROJETOINT',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'equipe',
            headerName: 'EQUIPE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'empresa2',
            headerName: 'EMPRESA2',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'obs',
            headerName: 'OBS',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'gerenciaplan',
            headerName: 'GERENCIAPLAN',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'gerenciareal',
            headerName: 'GERENCIAREAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'numerossd',
            headerName: 'NUMEROSSD',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statusssd',
            headerName: 'STATUSSSD',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'potelequipessd',
            headerName: 'POTELEQUIPESSD',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'responsabilidadessd',
            headerName: 'RESPONSABILIDADESSD',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'mosscan',
            headerName: 'MOSSCAN',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'compliance',
            headerName: 'COMPLIANCE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'quality',
            headerName: 'QUALITY',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'ehs',
            headerName: 'EHS',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'pdi',
            headerName: 'PDI',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statusiepms',
            headerName: 'STATUSIEPMS',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'faturamento',
            headerName: 'FATURAMENTO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statuspo',
            headerName: 'STATUSPO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'potelequipe',
            headerName: 'POTELEQUIPE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'poadicional',
            headerName: 'POADICIONAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'poadcmaterial',
            headerName: 'POADCMATERIAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statuspoadc',
            headerName: 'STATUSPOADC',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'poztexclaro',
            headerName: 'POZTEXCLARO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'fechamento',
            headerName: 'FECHAMENTO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'escopoatividade',
            headerName: 'ESCOPOATIVIDADE',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'tipodeinfra',
            headerName: 'TIPODEINFRA',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'localbaterias',
            headerName: 'LOCALBATERIAS',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'clusterhelix',
            headerName: 'CLUSTERHELIX',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'numeracaocrq',
            headerName: 'NUMERACAOCRQ',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'datainicial',
            headerName: 'DATAINICIAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'datafinal',
            headerName: 'DATAFINAL',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statuscrq',
            headerName: 'STATUSCRQ',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'crqsanotacoes',
            headerName: 'CRQSANOTACOES',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'detentora',
            headerName: 'DETENTORA',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'iddetentora',
            headerName: 'IDDETENTORA',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'outrosid',
            headerName: 'OUTROSID',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'formadeacesso',
            headerName: 'FORMADEACESSO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'acesso_1',
            headerName: 'ACESSO_1',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'datasolicitacao',
            headerName: 'DATASOLICITACAO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'inicioprevisto',
            headerName: 'INICIOPREVISTO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'finalprevisto',
            headerName: 'FINALPREVISTO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'statussolicitacao',
            headerName: 'STATUSSOLICITACAO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'numerosolicitacao',
            headerName: 'NUMEROSOLICITACAO',
            width: 100,
            align: 'left',
            type: 'string',
            editable: false,
        },
        {
            field: 'ultimaatualizacao',
            headerName: 'ULTIMAATUALIZACAO',
            width: 100,
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
        listarolloutzte();
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
                <ModalHeader>Rollout - ZTE</ModalHeader>
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
                            <Button color="link" onClick={gerarexcel}>
                                Exportar Excel
                            </Button>
 
 
                            <Box sx={{ height: '95%', width: '100%' }}>
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

Rolloutzte.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
};

export default Rolloutzte;
