import { useState, useEffect } from 'react';
import {
    Button,
    FormGroup,
    Input,
    Modal,
    ModalBody,
    ModalHeader,
    ModalFooter,
    InputGroup,
} from 'reactstrap';
import {
    DataGrid,
    GridActionsCellItem,
    gridPageCountSelector,
    gridPageSelector,
    useGridApiContext,
    useGridSelector,
    GridOverlay,
} from '@mui/x-data-grid';
import { Box, Autocomplete, TextField } from '@mui/material';
import PropTypes from 'prop-types';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import * as Icon from 'react-feather';
import 'react-toastify/dist/ReactToastify.css';
import { toast } from 'react-toastify';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import modoVisualizador from '../../../services/modovisualizador';

const Solicitacaoedicao = ({
    setshow,
    show,
    ididentificador,
    atualiza,
    novo,
    numero,
    projetousual,
    payload,
    origem,
}) => {
    const [mensagem, setmensagem] = useState('');
    const [mensagemsucesso, setmensagemsucesso] = useState('');
    const [loading, setloading] = useState(false);
    const [idsolicitante, setidsolicitante] = useState('');
    const [solicitante, setsolicitante] = useState('');
    const [solicitacaoitenslista, setsolicitacaoitenslista] = useState([]);
    const [idsolicitacao, setidsolicitacao] = useState('');
    const [pageSize, setPageSize] = useState(5);
    const [currentDate, setcurrentDate] = useState('');
    const [observacao, setobservacao] = useState('');
    const [os, setos] = useState('');
    const [emailmaterial, setemailmaterial] = useState('');
    const [produtos, setprodutos] = useState([]);
    const [itemModalAberto, setItemModalAberto] = useState(false);
    const [itemEditIndex, setItemEditIndex] = useState(null);
    const [itemForm, setItemForm] = useState({
        idproduto: '',
        descricao: '',
        quantidade: '',
        unidade: '',
        codigosku: '',
    });
    const [produtoSelecionado, setProdutoSelecionado] = useState(null);

    const togglecadastro = () => {
        setshow(!show);
    };

    const paramsBase = {
        idcliente: localStorage.getItem('sessionCodidcliente'),
        idusuario: localStorage.getItem('sessionId'),
        idloja: localStorage.getItem('sessionloja'),
        idnome: localStorage.getItem('sessionNome'),
        solicitacao: ididentificador,
        origem: 'SOLICITACAO',
        projeto: projetousual,
        obra: numero,
        deletado: 0,
    };

    async function carregarEmail() {
        const response = await api.get('v1/emails/aviso');
        setemailmaterial(response.data.emailmaterial);
    }

    async function carregarProdutos() {
        try {
            const r = await api.get('v1/produto/select');
            setprodutos(Array.isArray(r.data) ? r.data : []);
        } catch {
            setprodutos([]);
        }
    }

    const listasolicatacaoitens = async () => {
        try {
            setloading(true);
            const response = await api.get('v1/solicitacao/listaitens', { params: paramsBase });
            const rows = (Array.isArray(response.data) ? response.data : []).map((i, idx) => ({
                id: i.idsolicitacaoitens || i.id || idx,
                idproduto: i.idproduto,
                descricao: i.descricao,
                quantidade: i.quantidade,
                unidade: i.unidade,
                codigosku: i.codigosku || '',
            }));
            setsolicitacaoitenslista(rows);
            setmensagem('');
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };

    function ProcessaCadastro(e) {
        e.preventDefault();
        setmensagem('');
        setmensagemsucesso('');

        const sitesFonte =
            payload?.sites ??
            payload?.contexto?.sites ??
            [];

        const sites = (Array.isArray(sitesFonte) ? sitesFonte : []).map((s) => ({
            id: s.id,
            name: s.name,
            siteCode: s.siteCode,
            siteId: s.siteId,
            os: s.os,
        }));

        if (!sites.length) {
            toast.error('Selecione ao menos um site.');
            return;
        }

        const itensNormalizados = solicitacaoitenslista.map((i) => ({
            idproduto: Number(i.idproduto ?? 0),
            descricao: String(i.descricao ?? ''),
            quantidade: Number(i.quantidade ?? 0),
            unidade: String(i.unidade ?? ''),
            codigosku: i.codigosku ? String(i.codigosku) : '',
        }));

        if (!itensNormalizados.length) {
            toast.error('Adicione ao menos um item.');
            return;
        }

        if (itensNormalizados.some((it) => !it.idproduto || it.quantidade <= 0 || !it.unidade || !it.descricao)) {
            toast.error('Verifique os itens: produto, quantidade, unidade e descrição são obrigatórios.');
            return;
        }

        const contexto = {
            ...(payload?.contexto || {}),
            idcliente: localStorage.getItem('sessionCodidcliente'),
            idusuario: localStorage.getItem('sessionId'),
            idloja: localStorage.getItem('sessionloja'),
            // também mantemos os sites dentro de contexto para rastreabilidade
            sites,
        };

        const payloadSave = {
            idsolicitacao: novo === '0' ? ididentificador : undefined,
            numero: os,
            idsolicitante,
            observacao,
            data: currentDate,
            projeto: projetousual,
            idcliente: localStorage.getItem('sessionCodidcliente'),
            idusuario: localStorage.getItem('sessionId'),
            idloja: localStorage.getItem('sessionloja'),
            itens: itensNormalizados,
            origem,
            // ⇓⇓ IMPORTANTE: sites no nível raiz (fora do contexto)
            sites,
            // ⇓⇓ Mantém no contexto também
            contexto,
        };

        api
            .post('v1/projetohuawei/solicitacao-material-servico', payloadSave)
            .then((response) => {
                if (response.status === 201 || response.status === 200) {
                    setmensagem('');
                    setmensagemsucesso('Registro Salvo');
                    api.post('v1/email/ordemservico', {
                        dest: emailmaterial,
                        assunto: `Aviso de Solicitação de Material - PROJETO ${projetousual || ''}`,
                        osId: numero,
                    });
                    setshow(!show);
                    if (typeof atualiza === 'function') atualiza();
                } else {
                    setmensagem(String(response.status));
                    setmensagemsucesso('');
                }
            })
            .catch((err) => {
                setmensagem(err?.response?.data?.erro || 'Ocorreu um erro na requisição.');
                setmensagemsucesso('');
            });
    }


    const listaordemcompra = async () => {
        try {
            setloading(true);
            const response = await api.get('v1/solicitacaoid/lista', { params: paramsBase });
            if (Object.keys(response.data || {}).length === 0) {
                setidsolicitacao('');
                setsolicitante('');
                setcurrentDate('');
                setobservacao('');
                setsolicitacaoitenslista([]);
            } else {
                setidsolicitacao(response.data.id);
                setsolicitante(response.data.nome);
                setcurrentDate(response.data.data);
                setobservacao(response.data.observacao || '');
            }
        } catch (err) {
            setmensagem(err.message);
        } finally {
            setloading(false);
        }
    };

    function removerItem(index) {
        const copia = [...solicitacaoitenslista];
        copia.splice(index, 1);
        setsolicitacaoitenslista(copia);
    }

    function editarItem(index) {
        const row = solicitacaoitenslista[index];
        setItemEditIndex(index);
        setProdutoSelecionado(
            row?.idproduto ? produtos.find((p) => String((p.idproduto ?? p.value)) === String(row.idproduto)) || null : null
        );
        setItemForm({
            idproduto: row.idproduto || '',
            descricao: row.descricao || '',
            quantidade: row.quantidade || '',
            unidade: row.unidade || '',
            codigosku: row.codigosku || '',
        });
        setItemModalAberto(true);
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

    function CustomNoRowsOverlay() {
        return (
            <GridOverlay>
                <div>Nenhum dado encontrado</div>
            </GridOverlay>
        );
    }

    const columns = [
        {
            field: 'actions',
            headerName: 'Ação',
            type: 'actions',
            width: 120,
            align: 'center',
            getActions: (parametros) => [
                <GridActionsCellItem
                    icon={<EditIcon />}
                    label="Alterar"
                    title="Alterar"
                    onClick={() => editarItem(parametros.api.getRowIndex(parametros.id))}
                />,
                <GridActionsCellItem
                    disabled={modoVisualizador()}
                    icon={<DeleteIcon />}
                    label="Delete"
                    title="Delete"
                    onClick={() => removerItem(parametros.api.getRowIndex(parametros.id))}
                />,
            ],
        },
        { field: 'idproduto', headerName: 'Produto', width: 130, align: 'left', type: 'string' },
        { field: 'codigosku', headerName: 'SKU', width: 130, align: 'left', type: 'string' },
        {
            field: 'descricao',
            headerName: 'Descrição',
            width: 420,
            align: 'left',
            type: 'string',
            renderCell: (p) => <div style={{ whiteSpace: 'pre-wrap' }}>{p.value}</div>,
        },
        { field: 'quantidade', headerName: 'Quantidade', width: 140, align: 'right', type: 'number' },
        { field: 'unidade', headerName: 'Unidade', width: 150, align: 'center', type: 'string' },
    ];

    function abrirModalNovoItem() {
        setItemEditIndex(null);
        setProdutoSelecionado(null);
        setItemForm({
            idproduto: '',
            descricao: '',
            quantidade: '',
            unidade: '',
            codigosku: '',
        });
        setItemModalAberto(true);
    }

    function salvarItemModal() {
        if (!itemForm.idproduto || !itemForm.descricao || !itemForm.quantidade || !itemForm.unidade) {
            toast.error('Preencha produto, descrição, quantidade e unidade.');
            return;
        }
        if (Number(itemForm.quantidade) <= 0) {
            toast.error('Quantidade inválida.');
            return;
        }
        const novoItem = {
            id: itemEditIndex === null ? `local-${Date.now()}` : solicitacaoitenslista[itemEditIndex]?.id,
            idproduto: itemForm.idproduto,
            descricao: itemForm.descricao,
            quantidade: itemForm.quantidade,
            unidade: itemForm.unidade,
            codigosku: itemForm.codigosku || '',
        };
        if (itemEditIndex === null) {
            setsolicitacaoitenslista((prev) => [...prev, novoItem]);
        } else {
            const copia = [...solicitacaoitenslista];
            copia[itemEditIndex] = novoItem;
            setsolicitacaoitenslista(copia);
        }
        setItemModalAberto(false);
    }

    const iniciatabelas = async () => {
        const date = new Date();
        const formattedDate = date.toISOString().split('T')[0];
        setidsolicitacao(ididentificador || '');
        setos(numero);
        await carregarEmail();
        await carregarProdutos();
        if (novo === '0') {
            await listaordemcompra();
            await listasolicatacaoitens();
        } else {
            setsolicitante(localStorage.getItem('sessionNome') || '');
            setidsolicitante(localStorage.getItem('sessionId') || '');
            setcurrentDate(formattedDate);
            setsolicitacaoitenslista([]);
        }
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
            className="modal-dialog modal-xl modal-dialog-scrollable modal-fullscreen "
        >
            <ModalHeader toggle={togglecadastro.bind(null)} style={{ backgroundColor: 'white' }}>
                Solicitação de Material
            </ModalHeader>
            <ModalBody style={{ backgroundColor: 'white' }}>
                {mensagem.length > 0 ? (
                    <div className="alert alert-danger mt-2" role="alert">
                        {mensagem}
                    </div>
                ) : null}
                {mensagemsucesso.length > 0 ? (
                    <div className="alert alert-success" role="alert">
                        Registro Salvo
                    </div>
                ) : null}
                {loading ? (
                    <Loader />
                ) : (
                    <FormGroup>
                        <div className="row g-3">
                            {novo === '0' && (
                                <div className="col-2">
                                    Nº
                                    <Input type="text" value={idsolicitacao} placeholder="" disabled />
                                </div>
                            )}
                            <div className={novo === '0' ? 'col-sm-6' : 'col-sm-8'}>
                                Solicitante
                                <InputGroup className="comprimento-group">
                                    <Input type="hidden" value={idsolicitante} name="idsolicitante" />
                                    <Input type="text" value={solicitante} name="status" disabled />
                                </InputGroup>
                            </div>
                            <div className="col-2">
                                Data Solicitação
                                <Input
                                    type="date"
                                    value={currentDate}
                                    onChange={(e) => setcurrentDate(e.target.value)}
                                    placeholder=""
                                    disabled
                                />
                            </div>
                        </div>
                        <hr />
                        <div className="row g-3">
                            <div className="col-sm-4 d-md-flex align-items-center gap-2 ">
                                <b>Listagem</b>
                            </div>
                            <div className="col-sm-8 d-md-flex align-items-center gap-2 d-flex flex-row-reverse">
                                <Button color="link" onClick={abrirModalNovoItem}>
                                    <Icon.PlusCircle /> Adicionar Item
                                </Button>
                            </div>
                        </div>
                        <Box sx={{ height: 420, width: '100%' }}>
                            <DataGrid
                                rows={solicitacaoitenslista.map((r, idx) => ({ id: r.id ?? idx, ...r }))}
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
                                localeText={{
                                    columnMenuShowColumns: 'Mostra Colunas',
                                    columnMenuManageColumns: 'Gerencia Colunas',
                                    columnMenuFilter: 'Filtro',
                                    columnMenuHideColumn: 'Esconder',
                                    columnMenuUnsort: 'Desordenar',
                                    columnMenuSortAsc: 'Classificar por Crescente',
                                    columnMenuSortDesc: 'Classificar por Decrescente',
                                }}
                            />
                        </Box>
                        <br />
                        <div className="row g-3">
                            <div className="col-sm-12">
                                <b>Observações</b>
                                <Input
                                    type="textarea"
                                    onChange={(e) => setobservacao(e.target.value)}
                                    value={observacao}
                                    placeholder=""
                                />
                            </div>
                        </div>
                    </FormGroup>
                )}
            </ModalBody>
            <ModalFooter style={{ backgroundColor: 'white' }}>
                <Button color="success" onClick={ProcessaCadastro}>
                    Salvar
                </Button>
                <Button color="secondary" onClick={togglecadastro.bind(null)}>
                    Sair
                </Button>
            </ModalFooter>

            <Modal
                isOpen={itemModalAberto}
                toggle={() => setItemModalAberto(false)}
                backdrop="static"
                keyboard={false}
                className="modal-dialog modal-lg modal-dialog-scrollable"
            >
                <ModalHeader toggle={() => setItemModalAberto(false)} style={{ backgroundColor: 'white' }}>
                    {itemEditIndex === null ? 'Novo Item' : 'Alterar Item'}
                </ModalHeader>
                <ModalBody style={{ backgroundColor: 'white' }}>
                    <div className="row g-3">
                        <div className="col-sm-12">
                            <Autocomplete
                                options={produtos}
                                value={produtoSelecionado}
                                onChange={(e, val) => {
                                    setProdutoSelecionado(val);
                                    if (val) {
                                        setItemForm((p) => ({
                                            ...p,
                                            idproduto: val.idproduto ?? val.value,
                                            descricao: val.label ?? '',
                                            unidade: val.unidade || '',
                                            codigosku: val.codigosku || '',
                                        }));
                                    } else {
                                        setItemForm((p) => ({
                                            ...p,
                                            idproduto: '',
                                            descricao: '',
                                            unidade: '',
                                            codigosku: '',
                                        }));
                                    }
                                }}
                                getOptionLabel={(o) => (o?.label ? o.label : '')}
                                renderInput={(params) => <TextField {...params} label="Produto" />}
                                isOptionEqualToValue={(o, v) =>
                                    String(o.idproduto ?? o.value) === String(v.idproduto ?? v.value)
                                }
                            />
                        </div>
                        <div className="col-sm-8">
                            Descrição
                            <Input
                                type="text"
                                value={itemForm.descricao}
                                onChange={(e) => setItemForm((p) => ({ ...p, descricao: e.target.value }))}
                            />
                        </div>
                        <div className="col-sm-4">
                            SKU
                            <Input
                                type="text"
                                value={itemForm.codigosku}
                                onChange={(e) => setItemForm((p) => ({ ...p, codigosku: e.target.value }))}
                            />
                        </div>
                        <div className="col-sm-4">
                            Quantidade
                            <Input
                                type="number"
                                value={itemForm.quantidade}
                                onChange={(e) => setItemForm((p) => ({ ...p, quantidade: e.target.value }))}
                            />
                        </div>
                        <div className="col-sm-4">
                            Unidade
                            <Input
                                type="text"
                                value={itemForm.unidade}
                                onChange={(e) => setItemForm((p) => ({ ...p, unidade: e.target.value }))}
                            />
                        </div>
                    </div>
                </ModalBody>
                <ModalFooter style={{ backgroundColor: 'white' }}>
                    <Button color="success" onClick={salvarItemModal}>
                        Salvar Item
                    </Button>
                    <Button color="secondary" onClick={() => setItemModalAberto(false)}>
                        Cancelar
                    </Button>
                </ModalFooter>
            </Modal>
        </Modal>
    );
};

Solicitacaoedicao.propTypes = {
    show: PropTypes.bool.isRequired,
    setshow: PropTypes.func.isRequired,
    ididentificador: PropTypes.number,
    atualiza: PropTypes.node,
    novo: PropTypes.string,
    numero: PropTypes.string,
    projetousual: PropTypes.string,
    payload: PropTypes.any,
    origem: PropTypes.string,
};

export default Solicitacaoedicao;
