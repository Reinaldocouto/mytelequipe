import { useState, useEffect } from 'react';
import { Box } from '@mui/material';
import {
  DataGrid,
  gridPageCountSelector,
  gridPageSelector,
  useGridApiContext,
  useGridSelector,
  GridOverlay,
} from '@mui/x-data-grid';
import { Card, CardBody, CardTitle, Button, Input, InputGroup, Label } from 'reactstrap';
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import SearchIcon from '@mui/icons-material/Search';
import AutorenewIcon from '@mui/icons-material/Autorenew';
import api from '../../services/api';
import exportExcel from '../../data/exportexcel/Excelexport';
import modoVisualizador from '../../services/modovisualizador';

export default function Pessoas() {
  const [listamonitoramento, setlistamonitoramento] = useState([]);
  const [pesqendereco, setpesqendereco] = useState('');
  const [pesqplaca, setpesqplaca] = useState('');
  const [date, setdate] = useState('');

  const [mensagem, setmensagem] = useState('');
  const [pageSize, setPageSize] = useState(10);
  const [loading, setloading] = useState(false);
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [arquivo, setarquivo] = useState('');
  const [permission, setpermission] = useState(0);
  const params = {
    placa: pesqplaca,
    endereco: pesqendereco,
    horario: date,
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const loadinglistamonitoramento = async () => {
    try {
      setloading(true);
      await api.get('/v1/monitoramento', { params }).then((response) => {
        const filteredData = response.data;
        setlistamonitoramento(filteredData);
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  function userpermission() {
    const permissionstorage = JSON.parse(localStorage.getItem('permission'));
    setpermission(permissionstorage.pessoas === 1);
  }

  function limparfiltro() {
    setpesqplaca('');
    setdate('');
    setpesqendereco('');
    loadinglistamonitoramento();
  }

  function CustomNoRowsOverlay() {
    return (
      <GridOverlay>
        <div>Nenhum dado encontrado</div>
      </GridOverlay>
    );
  }

  const uploadarquivo = async (e) => {
    e.preventDefault();

    if (!arquivo) {
      setmensagem('Nenhum arquivo selecionado para atualizar!');
      return;
    }
    const formData = new FormData();
    formData.append('files', arquivo);
    const header = {
      headers: { 'Content-Type': 'multipart/form-data' },
    };

    try {
      setloading(true);

      const response = await api.post('v1/uploadmonitoramento', formData, header);
      if (response && response.data) {
        console.log(response);
        if (response.status === 200) {
          setmensagemsucesso('Upload concluido');
          loadinglistamonitoramento();
          setmensagem('');
          setarquivo('');
        } else {
          setmensagemsucesso('');
          setmensagem('Erro ao fazer upload!');
        }
      } else {
        throw new Error('Resposta inválida do servidor');
      }
    } catch (err) {
      if (err.response) {
        setmensagem(err.message);
        setmensagemsucesso('');
      } else {
        setmensagem('Erro: Tente novamente mais tarde!');
        setmensagemsucesso('');
      }
    } finally {
      setloading(false);
    }
  };

  const columns = [
    {
      field: 'id',
      headerName: 'ID',
      width: 80,
      align: 'left',
    },
    {
      field: 'horario',
      headerName: 'Horário',
      type: 'datetime',
      width: 180,
      align: 'left',
    },
    {
      field: 'dataInicio',
      headerName: 'Data Início',
      type: 'string',
      width: 130,
      align: 'left',
    },
    {
      field: 'dataFim',
      headerName: 'Data Fim',
      type: 'string',
      width: 130,
      align: 'left',
    },
    {
      field: 'placa',
      headerName: 'Placa',
      width: 120,
      align: 'left',
    },
    {
      field: 'endereco',
      headerName: 'Endereço',
      width: 300,
      align: 'left',
    },
    {
      field: 'latitude',
      headerName: 'Latitude',
      type: 'number',
      width: 130,
      align: 'left',
    },
    {
      field: 'longitude',
      headerName: 'Longitude',
      type: 'number',
      width: 130,
      align: 'left',
    },
    {
      field: 'velocidade',
      headerName: 'Velocidade',
      width: 120,
      align: 'left',
    },
    {
      field: 'ignicao',
      headerName: 'Ignição',
      width: 100,
      align: 'left',
    },
    {
      field: 'bateria',
      headerName: 'Bateria',
      width: 120,
      align: 'left',
    },
    {
      field: 'sinal',
      headerName: 'Sinal',
      width: 120,
      align: 'left',
    },
    {
      field: 'gps',
      headerName: 'GPS',
      width: 120,
      align: 'left',
    },
    {
      field: 'evento',
      headerName: 'Evento',
      width: 200,
      align: 'left',
    },
    {
      field: 'hodometro',
      headerName: 'Hodômetro',
      width: 150,
      align: 'left',
    },
    {
      field: 'criadoEm',
      headerName: 'Criado Em',
      type: 'string',
      width: 180,
      align: 'left',
    },
  ];

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

  const relacionamentotipo = () => {
    // api.get('/v1/tiporelacionamento', { params }).then((response) => {
    //   console.log(response.data);
    // });
  };

  const iniciatabelas = () => {
    loadinglistamonitoramento();
    relacionamentotipo();
  };

  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);

  const gerarexcel = () => {
    const toUpperCaseRow = (row) => {
      const newRow = {};
      Object.keys(row).forEach((key) => {
        const value = row[key];
        newRow[key] = typeof value === 'string' ? value.toUpperCase() : value;
      });
      return newRow;
    };

    const excelData = listamonitoramento.map((item) => {
      const row = {
        ID: item.id,
        Horario: item.horario,
        'Data Inicio': item.dataInicio,
        'Data Fim': item.dataFim,
        Placa: item.placa,
        Endereco: item.endereco,
        Latitude: item.latitude?.toString().replace('.', ','),
        Longitude: item.longitude?.toString().replace('.', ','),
        Velocidade: item.velocidade,
        Ignição: item.ignicao,
        Bateria: item.bateria,
        Sinal: item.sinal,
        GPS: item.gps,
        Evento: item.evento,
        Hodometro: item.hodometro,
        'Criado em': item.criadoEm,
      };

      return toUpperCaseRow(row);
    });

    exportExcel({ excelData, fileName: 'monitoramento' });
  };

  return (
    <div>
      {/**filtro */}
      {permission && (
        <div>
          <Card>
            <CardBody className="bg-light">
              <CardTitle tag="h4" className="mb-0">
                Listagem de monitoramento
              </CardTitle>
            </CardBody>
            <CardBody style={{ backgroundColor: 'white' }}>
              {mensagem.length !== 0 ? (
                <div className="alert alert-danger mt-2" role="alert">
                  {mensagem}
                </div>
              ) : null}
              {mensagemsucesso.length > 0 ? (
                <div className="alert alert-success" role="alert">
                  {' '}
                  {mensagemsucesso}
                </div>
              ) : null}

              <div className="row g-3">
                <div className="col-sm-12">
                  <Label>Selecione o arquivo de atualização de pessoas</Label>
                  <div className="d-flex flex-row-reverse custom-file">
                    <InputGroup>
                      <Input
                        type="file"
                        onChange={async (e) => {
                          const file = e.target.files[0];

                          setarquivo(e.target.files[0]);
                          if (file) {
                            try {
                              //const jsonData = await excelReader(file);
                              //console.log(jsonData);
                              //setListaAtualizacaoPessoa(jsonData);
                            } catch (error) {
                              console.error('Erro ao ler o arquivo Excel:', error); // Tratar erro
                            }
                          }
                        }}
                        className="custom-file-input"
                        id="customFile3"
                        disabled={modoVisualizador()}
                      />
                      <Button color="primary" onClick={uploadarquivo} disabled={modoVisualizador()}>
                        Atualizar{' '}
                      </Button>
                    </InputGroup>
                  </div>
                </div>
                <div>
                  <InputGroup>
                    <Input
                      type="date"
                      className="mr-4"
                      placeholder="Data"
                      onChange={(e) => setdate(e.target.value)}
                      value={date}
                    ></Input>
                    <Input
                      type="text"
                      placeholder="Pesquise por placa"
                      onChange={(e) => setpesqplaca(e.target.value)}
                      value={pesqplaca}
                    ></Input>
                  </InputGroup>
                </div>

                <div className="col-sm-6 pt-4 mt-4">
                  <InputGroup>
                    <Input
                      type="text"
                      placeholder="Pesquise por endereço"
                      onChange={(e) => setpesqendereco(e.target.value)}
                      value={pesqendereco}
                    ></Input>
                    <Button color="primary" onClick={() => loadinglistamonitoramento()}>
                      {' '}
                      <SearchIcon />
                    </Button>
                    <Button color="primary" onClick={() => limparfiltro()}>
                      {' '}
                      <AutorenewIcon />
                    </Button>
                  </InputGroup>
                </div>
              </div>
              <br></br>
            </CardBody>
            {/**tabela*/}
            <CardBody style={{ backgroundColor: 'white' }}>
              <Button color="link" onClick={() => gerarexcel()}>
                Exportar Excel
              </Button>
              <Box
                sx={{
                  height: listamonitoramento.length > 0 ? '100%' : 500,
                  width: '100%',
                  textAlign: 'right',
                }}
              >
                <DataGrid
                  rows={listamonitoramento}
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
                  //opções traduzidas da tabela
                  localeText={{
                    // Column menu text
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
            </CardBody>
          </Card>
        </div>
      )}
    </div>
  );
}
