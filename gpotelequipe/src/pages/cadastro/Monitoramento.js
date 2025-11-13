import { useState, useEffect, useMemo } from 'react';
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

// Monitoramento com painel/dashboard no topo
export default function Pessoas() {
  const [listamonitoramento, setlistamonitoramento] = useState([]);
  const [pesqendereco, setpesqendereco] = useState('');
  const [pesqplaca, setpesqplaca] = useState('');
  const [date, setdate] = useState('');
  const [mostrarPainel, setMostrarPainel] = useState(true);

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
      const response = await api.get('/v1/monitoramento', { params });
      const filteredData = response.data;
      setlistamonitoramento(filteredData);
      setmensagem('');
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
    const nomeArquivo = arquivo.name.toLowerCase();
    const isExcel =
      nomeArquivo.endsWith('.xls') ||
      nomeArquivo.endsWith('.xlsx') ||
      arquivo.type.includes('sheet');
    const isZip =
      nomeArquivo.endsWith('.zip') ||
      arquivo.type === 'application/zip' ||
      arquivo.type === 'application/x-zip-compressed';

    if (!isExcel && !isZip) {
      setmensagem('Formato inválido! Envie um arquivo Excel (.xls, .xlsx) ou ZIP (.zip).');
      return;
    }

    // 🔄 Monta o nome final (mantém extensão original)
    const extensao = nomeArquivo.split('.').pop();
    const nomeSemAcento = `monitoramento.${extensao}`;
    const arquivoModificado = new File([arquivo], nomeSemAcento, { type: arquivo.type });
    formData.append('files', arquivoModificado);
    const header = {
      headers: { 'Content-Type': 'multipart/form-data' },
    };
    try {
      setloading(true);

      const response = await api.post('v1/uploadmonitoramento', formData, header);
      if (response && response.data) {
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

  // helpers
  const parseSpeed = (velStr) => {
    if (!velStr) return 0;
    // exemplos: "0 km/h" ou "120" ou "120 km/h"
    const nums = String(velStr)
      .replace(/[^0-9.,]/g, '')
      .replace(',', '.');
    const v = parseFloat(nums);
    return Number.isNaN(v) ? 0 : v;
  };

  const parseBRDateTime = (brDateTimeStr) => {
    // espera format "dd/MM/yyyy HH:mm:ss" ou "dd/MM/yyyy HH:mm"
    if (!brDateTimeStr) return null;
    const parts = String(brDateTimeStr).trim().split(' ');
    if (parts.length === 0) return null;
    const datePart = parts[0];
    const timePart = parts[1] || '00:00:00';
    const [day, month, year] = datePart.split('/').map((s) => parseInt(s, 10));
    const timeSegments = timePart.split(':').map((s) => parseInt(s, 10));
    const hh = timeSegments[0] || 0;
    const mm = timeSegments[1] || 0;
    const ss = timeSegments[2] || 0;
    // Note: monthIndex is zero-based
    if (!day || !month || !year) return null;
    return new Date(year, month - 1, day, hh, mm, ss);
  };

  const isOutOfWork = (dateObj) => {
    if (!dateObj) return false;
    const day = dateObj.getDay(); // 0=domingo, 1=segunda, ... 6=sábado
    const hour = dateObj.getHours();

    // Domingo nunca é permitido
    if (day === 0) return true;

    if (day === 1) {
      // Segunda: 06h até 21:59
      return !(hour >= 6 && hour < 22);
    }

    if (day >= 2 && day <= 5) {
      // Terça a sexta: 05h até 21:59
      return !(hour >= 5 && hour < 22);
    }

    if (day === 6) {
      // Sábado: 05h até 15:59
      return !(hour >= 5 && hour < 16);
    }

    return true;
  };

  // indicadores calculados a partir do array atual (respeita filtros porque listamonitoramento já é filtrado pela API)
  const indicadores = useMemo(() => {
    const speedIncidents = [];
    const outOfHoursIncidents = [];

    listamonitoramento.forEach((item) => {
      const dt = parseBRDateTime(item.horario);
      console.log(dt);
      const speed = parseSpeed(item.velocidade);
      if (speed > 120) {
        speedIncidents.push({ ...item, _parsedHorario: dt, _velNumber: speed });
      }
      if (isOutOfWork(dt)) {
        outOfHoursIncidents.push({ ...item, _parsedHorario: dt });
      }
    });

    // agrupar por placa (para relatórios resumidos)
    const groupByPlaca = (arr) => {
      const groups = {};
      arr.forEach((r) => {
        const p = r.placa || 'SEM_PLACA';
        if (!groups[p]) groups[p] = [];
        groups[p].push(r);
      });
      return groups;
    };

    return {
      total: listamonitoramento.length,
      speedCount: speedIncidents.length,
      outOfHoursCount: outOfHoursIncidents.length,
      speedIncidents,
      outOfHoursIncidents,
      speedByPlaca: groupByPlaca(speedIncidents),
      outOfHoursByPlaca: groupByPlaca(outOfHoursIncidents),
    };
  }, [listamonitoramento]);

  // Export detalhe de um conjunto (usa exportExcel util já existente)
  const toUpperCaseRow = (row) => {
    const newRow = {};
    Object.keys(row).forEach((key) => {
      const value = row[key];
      newRow[key] = typeof value === 'string' ? value.toUpperCase() : value;
    });
    return newRow;
  };

  const exportDetail = (records, fileName) => {
    const excelData = records.map((item) =>
      toUpperCaseRow({
        ID: item.id,
        Horario: item.horario,
        'Data Inicio': item.dataInicio,
        'Data Fim': item.dataFim,
        Placa: item.placa,
        Endereco: item.endereco,
        Latitude: item.latitude?.toString().replace('.', ',') || '',
        Longitude: item.longitude?.toString().replace('.', ',') || '',
        Velocidade: item.velocidade,
        Ignição: item.ignicao,
        Bateria: item.bateria,
        Sinal: item.sinal,
        GPS: item.gps,
        Evento: item.evento,
        Hodômetro: item.hodometro,
        'Criado em': item.criadoEm,
      }),
    );

    exportExcel({ excelData, fileName });
  };

  const exportSpeedDetails = () =>
    exportDetail(indicadores.speedIncidents, 'monitoramento_velocidade_acima_120');
  const exportOutOfHoursDetails = () =>
    exportDetail(indicadores.outOfHoursIncidents, 'monitoramento_fora_horario_trabalho');
  const exportAllDetails = () => exportDetail(listamonitoramento, 'monitoramento_todos_registros');

  const columns = [
    { field: 'id', headerName: 'ID', width: 80, align: 'left' },
    { field: 'horario', headerName: 'Horário', type: 'datetime', width: 180, align: 'left' },
    { field: 'dataInicio', headerName: 'Data Início', type: 'string', width: 130, align: 'left' },
    { field: 'dataFim', headerName: 'Data Fim', type: 'string', width: 130, align: 'left' },
    { field: 'placa', headerName: 'Placa', width: 120, align: 'left' },
    { field: 'endereco', headerName: 'Endereço', width: 300, align: 'left' },
    { field: 'latitude', headerName: 'Latitude', type: 'number', width: 130, align: 'left' },
    { field: 'longitude', headerName: 'Longitude', type: 'number', width: 130, align: 'left' },
    { field: 'velocidade', headerName: 'Velocidade', width: 120, align: 'left' },
    { field: 'ignicao', headerName: 'Ignição', width: 100, align: 'left' },
    { field: 'bateria', headerName: 'Bateria', width: 120, align: 'left' },
    { field: 'sinal', headerName: 'Sinal', width: 120, align: 'left' },
    { field: 'gps', headerName: 'GPS', width: 120, align: 'left' },
    { field: 'evento', headerName: 'Evento', width: 200, align: 'left' },
    { field: 'hodometro', headerName: 'Hodômetro', width: 150, align: 'left' },
    { field: 'criadoEm', headerName: 'Criado Em', type: 'string', width: 180, align: 'left' },
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

  const relacionamentotipo = () => {};

  const iniciatabelas = () => {
    loadinglistamonitoramento();
    relacionamentotipo();
  };

  useEffect(() => {
    iniciatabelas();
    userpermission();
  }, []);

  const gerarexcel = () => {
    const excelData = listamonitoramento.map((item) =>
      toUpperCaseRow({
        ID: item.id,
        Horario: item.horario,
        'Data Inicio': item.dataInicio,
        'Data Fim': item.dataFim,
        Placa: item.placa,
        Endereco: item.endereco,
        Latitude: item.latitude?.toString().replace('.', ',') || '',
        Longitude: item.longitude?.toString().replace('.', ',') || '',
        Velocidade: item.velocidade,
        Ignição: item.ignicao,
        Bateria: item.bateria,
        Sinal: item.sinal,
        GPS: item.gps,
        Evento: item.evento,
        Hodometro: item.hodometro,
        'Criado em': item.criadoEm,
      }),
    );

    exportExcel({ excelData, fileName: 'monitoramento' });
  };

  return (
    <div>
      {permission && (
        <div>
          <Card>
            <CardBody className="bg-light d-flex justify-content-between align-items-center">
              <CardTitle tag="h4" className="mb-0">
                Painel de Monitoramento
              </CardTitle>
              <Button color="secondary" size="sm" onClick={() => setMostrarPainel(!mostrarPainel)}>
                {mostrarPainel ? 'Ocultar' : 'Exibir'} painel
              </Button>
            </CardBody>

            {/* === DASHBOARD (topo) === */}
            {mostrarPainel && (
              <CardBody className="bg-light">
                <div className="row g-3">
                  {/* Total Registros */}
                  <div className="col-sm-4">
                    <div
                      className="p-3 rounded-3 shadow-sm text-center"
                      style={{ backgroundColor: '#e9f2ff' }}
                    >
                      <h6 className="text-muted">Registros filtrados</h6>
                      <h3 className="fw-bold text-primary">{indicadores.total}</h3>
                      <Button
                        size="sm"
                        color="primary"
                        className="mt-2"
                        onClick={exportAllDetails}
                        disabled={modoVisualizador()}
                      >
                        Exportar todos
                      </Button>
                    </div>
                  </div>

                  {/* Velocidade > 120 */}
                  <div className="col-sm-4">
                    <div
                      className="p-3 rounded-3 shadow-sm text-center"
                      style={{ backgroundColor: '#fdeaea' }}
                    >
                      <h6 className="text-muted">Velocidade &gt; 120 km/h</h6>
                      <h3 className="fw-bold text-danger">{indicadores.speedCount}</h3>
                      <Button
                        size="sm"
                        color="danger"
                        className="mt-2"
                        onClick={exportSpeedDetails}
                        disabled={modoVisualizador()}
                      >
                        Exportar detalhes
                      </Button>
                    </div>
                  </div>

                  {/* Fora do horário */}
                  <div className="col-sm-4">
                    <div
                      className="p-3 rounded-3 shadow-sm text-center"
                      style={{ backgroundColor: '#fff7e6' }}
                    >
                      <h6 className="text-muted">Uso fora do horário</h6>
                      <h3 className="fw-bold text-warning">{indicadores.outOfHoursCount}</h3>
                      <Button
                        size="sm"
                        color="warning"
                        className="mt-2"
                        onClick={exportOutOfHoursDetails}
                        disabled={modoVisualizador()}
                      >
                        Exportar detalhes
                      </Button>
                    </div>
                  </div>
                </div>

                {/* Top placas */}
                {Object.entries(indicadores.speedByPlaca).length > 0 && (
                  <div className="mt-3 p-3 rounded-3 bg-white shadow-sm">
                    <small className="text-secondary fw-semibold">
                      🚗 Top placas com mais eventos de velocidade (&gt; 120):
                    </small>
                    <ul className="mt-2 mb-0 ps-3">
                      {Object.entries(indicadores.speedByPlaca)
                        .sort((a, b) => b[1].length - a[1].length)
                        .slice(0, 5)
                        .map(([placa, arr]) => (
                          <li key={placa}>
                            <span className="fw-bold">{placa}</span> — {arr.length} registros
                          </li>
                        ))}
                    </ul>
                  </div>
                )}
              </CardBody>
            )}

            {/* === filtros e upload === */}
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
                              // leitura opcional do arquivo antes do upload
                            } catch (error) {
                              console.error('Erro ao ler o arquivo Excel:', error);
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

            {/* tabela e export geral */}
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
            </CardBody>
          </Card>
        </div>
      )}
    </div>
  );
}
