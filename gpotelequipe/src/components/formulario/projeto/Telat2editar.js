import { useState, useEffect } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Input } from 'reactstrap';
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
import Select from 'react-select';
import PropTypes from 'prop-types';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import DeleteIcon from '@mui/icons-material/Delete';
import { Box, Typography } from '@mui/material';
import { toast, ToastContainer } from 'react-toastify';
import modoVisualizador from '../../../services/modovisualizador';
import api from '../../../services/api';
import Excluirregistro from '../../Excluirregistro';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Telat2editar = ({ setshow, show, titulo, pmuf, sigla, idobra, idpmtslocal }) => {
  const [descricaocod, setdescricaocod] = useState([]);
  const [selectedoptiondescricao, setselectedoptiondescricao] = useState({
    value: null,
    label: null,
  });
  const [iddescricaocod, setiddescricaocod] = useState(0);
  const [loading, setloading] = useState(false);
  const [regional, setregional] = useState(pmuf);
  const [rowSelectionModel, setRowSelectionModel] = useState([]);
  const [telaexclusaot2, settelaexclusaot2] = useState(false);
  const [paginationModelatividade, setPaginationModelatividade] = useState({
    pageSize: 10,
    page: 0,
  });
  const [idt2, setidt2] = useState(0);
  const [quantidade, setquantidade] = useState(1);
  const [atividades, setatividades] = useState([]);

  const params = {
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    uf: pmuf,
    idobraloca: idobra,
    idpmts: idpmtslocal,
  };

  const toggle = () => {
    setshow(!show);
  };

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
    const rowCount = apiRef.current.getRowsCount(); // Obtém total de itens
    return (
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          padding: '10px',
        }}
      >
        <Typography variant="body2">Total de itens: {rowCount}</Typography>

        <Pagination
          color="primary"
          count={pageCount}
          page={page + 1}
          onChange={(event, value1) => apiRef.current.setPage(value1 - 1)}
        />
      </Box>
    );
  }

  const listadescricao = async () => {
    try {
      setloading(true);
      await api.get('v1/projetotelefonica/listacodt2', { params }).then((response) => {
        setdescricaocod(response.data);
      });
    } catch (err) {
      toast.error(err.message);
    } finally {
      setloading(false);
    }
  };

  function deleteUser(stat) {
    setidt2(stat);
    settelaexclusaot2(true);
  }

  const colunasatividades = [
    {
      field: 'actions',
      headerName: 'Ação',
      type: 'actions',
      width: 80,
      align: 'center',
      getActions: (parametros) => [
        <GridActionsCellItem
          icon={<DeleteIcon />}
          disabled={modoVisualizador()}
          label="Delete"
          onClick={() => deleteUser(parametros.id)}
        />,
      ],
    },
    {
      field: 'empresa',
      headerName: 'EMPRESA',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'site',
      headerName: 'SITE',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'itemt2',
      headerName: 'ITEM T2',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'codfornecedor',
      headerName: 'COD FORNECEDOR',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'fabricante',
      headerName: 'FABRICANTE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'numerodocontrato',
      headerName: 'NUMERO DO CONTRATO',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 't2codmatservsw',
      headerName: 'T2 - COD MAT SERV SW',
      width: 300,
      align: 'left',
      editable: false,
    },
    {
      field: 't2descricaocod',
      headerName: 'T2 DESCRICAO COD',
      width: 400,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitarioliqliq',
      headerName: 'VLR UNITARIO LIQLIQ',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitarioliq',
      headerName: 'VLR UNITARIO LIQ',
      width: 180,
      align: 'left',
      editable: false,
    },
    {
      field: 'quant',
      headerName: 'QUANT',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'unid',
      headerName: 'UNID',
      width: 100,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrunitariocimposto',
      headerName: 'VLR UNITARIO C/ IMPOSTO',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrcimpsicms',
      headerName: 'VLR C/ IMP S ICMS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'vlrtotalcimpostos',
      headerName: 'VLR TOTAL C/ IMPOSTOS',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'itemt4',
      headerName: 'ITEM T4',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't4codeqmatswserv',
      headerName: 'T4 - COD EQ MAT SW SERV',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 't4descricaocod',
      headerName: 'T4 - DESCRIÇÃO COD',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel2',
      headerName: 'PEP NÍVEL 2',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'idlocalidade',
      headerName: 'ID LOCALIDADE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'pepnivel3',
      headerName: 'PEP NÍVEL 3',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'descricaoobra',
      headerName: 'DESCRIÇÃO DA OBRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'idobra',
      headerName: 'ID OBRA',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'enlace',
      headerName: 'ENLACE',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'gestor',
      headerName: 'GESTOR',
      width: 150,
      align: 'left',
      editable: false,
    },
    {
      field: 'tipo',
      headerName: 'TIPO',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'responsavel',
      headerName: 'RESPONSAVAEL',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'categoria',
      headerName: 'CATEGORIA',
      width: 150,
      align: 'left',
      editable: false,
    },

    {
      field: 'tecnologia',
      headerName: 'TECNOLOGIA',
      width: 150,
      align: 'left',
      editable: false,
    },
  ];

  const listatarefas = async () => {
    try {
      setloading(true);
      console.log(`id obra ${idobra}`);
      await api.get('v1/projetotelefonica/listat2', { params }).then((response) => {
        setatividades(response.data);
      });
    } catch (err) {
      if (err.response) {
        toast.error(err.response.data.erro);
      } else {
        toast.error('Ocorreu um erro na requisição.');
      }
    } finally {
      setloading(false);
    }
  };

  const handleChangedescricao = (stat) => {
    if (stat !== null) {
      setiddescricaocod(stat.value);
      setselectedoptiondescricao({ value: stat.value, label: stat.label });
    } else {
      setiddescricaocod(0);
      setselectedoptiondescricao({ value: null, label: null });
    }
  };

  function ProcessaCadastro() {
    const qnt = Number(quantidade);
    console.log(qnt);

    if (!iddescricaocod) {
      toast.warning('Selecione uma T2 descrição');
      return;
    }

    if (qnt < 1) {
      toast.warning('Quantidade deve ser maior que 0');
      return;
    }

    api
      .post('v1/projetotelefonica/gerardt2', {
        iddescricaocod,
        quantidade,
        obra: idobra,
        site: sigla,
        idmpts: idpmtslocal,
        idusuario: localStorage.getItem('sessionId'),
      })
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro Salvo');
          listatarefas();
        } else {
          toast.error(response.status);
        }
      })
      .catch((err) => {
        if (err.response) {
          toast.error(err.response.data.erro);
        } else {
          toast.error('Ocorreu um erro na requisição.');
        }
      });
  }

  const iniciatabelas = () => {
    setregional(pmuf);
    setquantidade(1);
    listadescricao();
    listatarefas();
  };

  useEffect(() => {
    iniciatabelas();
  }, []);

  const gerarexcel = () => {
    const excelData = atividades.map((item) => ({
      EMPRESA: item.empresa,
      SITE: item.site,
      'ITEM T2': item.itemt2,
      'CÓD. FORNECEDOR': item.codfornecedor,
      FABRICANTE: 'TELEQUIPE',
      'NUMERO DO CONTRATO': item.numerodocontrato,
      'T2 - COD MAT_SERV_SW': item.t2codmatservsw,
      'T2 - DESCRIÇÃO COD': item.t2descricaocod,
      'VLR_UNITÁRIO LIQLIQ': item.vlrunitarioliqliq === 0 ? '' : item.vlrunitarioliqliq,
      'VLR UNITÁRIO LIQ': item.vlrunitarioliq,
      QUANT: item.quant,
      UNID: item.unid,
      'VLR UNITÁRIO C/ IMPOSTO': item.vlrunitariocimposto,
      'VLR C_IMP S_ICMS': item.vlrcimpsicms,
      'VLR TOTAL C_IMPOSTOS': item.vlrtotalcimpostos,
      'ITEM T4': item.itemt4,
      'T4 - COD EQ_ MAT_SW_SERV': item.t4codeqmatswserv,
      'T4 - DESCRIÇÃO COD': item.t4descricaocod,
      'PEP NÍVEL 2': item.pepnivel2,
      'ID LOCALIDADE': item.idlocalidade,
      'PEP NÍVEL 3': item.pepnivel3,
      'DESCRIÇÃO DA OBRA': item.descricaoobra,
      'ID OBRA': item.idobra,
      'DATA DE ENTREGA': '',
      ENLACE: item.enlace,
      GESTOR: item.gestor,
      'TIPO (Hardware; Software; Serviço; Material)': item.tipo,
      Responsável: item.responsavel,
      CATEGORIA: item.categoria,
      TECNOLOGIA: item.tecnologia,
    }));
    exportExcel({ excelData, fileName: 't2' });
  };

  return (
    <>
      <Modal
        isOpen={show}
        toggle={toggle.bind(null)}
        backdrop="static"
        keyboard={false}
        className="modal-dialog modal-fullscreen modal-dialog-scrollable modal-fullscreen "
      >
        <ModalHeader toggle={toggle.bind(null)}>{titulo}</ModalHeader>
        <ModalBody>
          {telaexclusaot2 ? (
            <>
              <Excluirregistro
                show={telaexclusaot2}
                setshow={settelaexclusaot2}
                ididentificador={idt2}
                quemchamou="CRIACAOT2"
                atualiza={listatarefas}
              />{' '}
            </>
          ) : null}

          <ToastContainer
            style={{ zIndex: 9999999 }}
            position="top-right"
            autoClose={2000}
            hideProgressBar={false}
            newestOnTop
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />

          <div className="row g-3">
            <div className="col-sm-1">
              Regional
              <Input type="text" placeholder="Regional" value={regional} disabled />
            </div>
            <div className="col-sm-5">
              T2 - Descrição Cod
              <Select
                isClearable
                isSearchable
                name="descricao"
                options={descricaocod}
                placeholder="Selecione"
                isLoading={loading}
                onChange={handleChangedescricao}
                value={selectedoptiondescricao}
              />
            </div>
            <div className="col-sm-1">
              Qtd
              <Input
                type="number"
                onChange={(e) => setquantidade(e.target.value)}
                value={quantidade}
                placeholder="qtd"
              />
            </div>
            <div className="col-sm-2">
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'flex-end',
                  height: '100%',
                }}
              >
                <Button color="primary" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
                  Adicionar Tarefa
                </Button>
              </div>
            </div>
            <div className="col-sm-2">
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'flex-end',
                  height: '100%',
                }}
              >
                <Button color="primary" onClick={gerarexcel} disabled={modoVisualizador()}>
                  Gerar Excel
                </Button>
              </div>
            </div>
          </div>

          <br />

          <Box sx={{ height: atividades.length > 0 ? '90%' : 400, width: '100%' }}>
            <DataGrid
              rows={atividades}
              columns={colunasatividades}
              loading={loading}
              disableSelectionOnClick
              checkboxSelection
              processRowUpdate={(newRow) => {
                // Atualiza a linha editada no estado
                setatividades((prevRows) =>
                  prevRows.map((row) => (row.id === newRow.id ? newRow : row)),
                );
                return newRow;
              }}
              onRowSelectionModelChange={(newRowSelectionModel) => {
                setRowSelectionModel(newRowSelectionModel);

                const selecionados = atividades.filter((row) =>
                  newRowSelectionModel.includes(row.id),
                );

                const quantidadesSelecionadas = selecionados.map((row) => row.qtd); // ou row.quantidade
                setquantidade(quantidadesSelecionadas[0] ?? null);
              }}
              rowSelectionModel={rowSelectionModel}
              experimentalFeatures={{ newEditingApi: true }}
              components={{
                Pagination: CustomPagination,
                LoadingOverlay: LinearProgress,
                NoRowsOverlay: CustomNoRowsOverlay,
              }}
              localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
              paginationModel={paginationModelatividade}
              onPaginationModelChange={setPaginationModelatividade}
            />
          </Box>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={toggle.bind(null)}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>
    </>
  );
};

Telat2editar.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  titulo: PropTypes.string,
  pmuf: PropTypes.string,
  sigla: PropTypes.string,
  idobra: PropTypes.string,
  idpmtslocal: PropTypes.string,
};
export default Telat2editar;
