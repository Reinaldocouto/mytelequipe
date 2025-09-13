import { useState, useEffect } from 'react';
import ReactApexChart from 'react-apexcharts';
import PropTypes from 'prop-types';

const removerAcentos = (texto = '') => texto.normalize('NFD').replace(/[\u0300-\u036f]/g, '');

const normalizarCategoria = (categoria) => {
  const cat = (categoria || '').trim(); // garante que nunca seja null/undefined
  if (!cat) return { key: 'selecione', label: 'Selecione' };
  const c = removerAcentos(cat.toLowerCase());
  if (c.includes('em andamento')) return { key: 'emandamento', label: 'Em Andamento' };
  if (c.includes('emitir')) return { key: 'emitirnf', label: 'Emitir NF' };
  if (c.includes('análise')) return { key: 'docaguardaanalise', label: 'Doc. Aguarda Análise' };
  if (c.includes('tx')) return { key: 'aguardatx', label: 'Aguarda TX' };
  if (c.includes('aceitacao')) return { key: 'aguardaaceitacao', label: 'Aguarda Aceitação' };
  if (c.includes('faturamento'))
    return { key: 'solicitadofaturamento', label: 'Solicitado Faturamento' };
  return { key: removerAcentos(cat.toLowerCase().replace(/\s+/g, '')), label: cat };
};

const calcularResumo = (relatorioFaturamento) => {
  let total = 0;
  const categorias = {};

  relatorioFaturamento.forEach(({ fat, valorafaturar }) => {
    const valor = Number(valorafaturar?.replace(',', '.')) || 0;

    const { key, label } = normalizarCategoria(fat);

    if (!categorias[key]) categorias[key] = { label, valor: 0 };
    categorias[key].valor += valor;
    total += valor;
  }); 

  const resumo = Object.values(categorias).map(({ label, valor }) => ({
    categoria: label,
    valor: Number(valor.toFixed(2)),
    percentual: total ? Number(((valor / total) * 100).toFixed(0)) : 0,
  }));

  return { resumo, total };
};

const PainelGraficosFAT = ({ relatorioFaturamento = [] }) => {
  const [dadosResumo, setDadosResumo] = useState([]);
  const [totalGeral, setTotalGeral] = useState(0);
  const [series, setSeries] = useState([]);
  const [opcoes, setOpcoes] = useState({});

  useEffect(() => {
    const { resumo, total } = calcularResumo(relatorioFaturamento);
    setDadosResumo(resumo);
    setTotalGeral(total);

    const valoresPercentuais = resumo.map(({ percentual }) => percentual);
    const labels = resumo.map(({ categoria }) => categoria);
    const cores = [
      '#1f77b4',
      '#ff7f0e',
      '#2ca02c',
      '#d62728',
      '#9467bd',
      '#8c564b',
      '#e377c2',
      '#7f7f7f',
      '#bcbd22',
      '#17becf',
    ];

    setSeries(valoresPercentuais);
    setOpcoes({
      chart: { type: 'pie', height: 400 },
      labels,
      colors: cores,
      dataLabels: {
        enabled: true,
        formatter: (val) => `${val.toFixed(0)}%`,
        style: { fontSize: '12px', fontWeight: 'bold', colors: ['#fff'] },
      },
      legend: {
        position: 'right',
        horizontalAlign: 'center',
        fontSize: '12px',
        markers: { width: 12, height: 12, radius: 12 },
        itemMargin: { horizontal: 5, vertical: 5 },
      },
      tooltip: {
        y: {
          formatter: (value, { seriesIndex }) => {
            const item = resumo[seriesIndex];
            return `${item.percentual}% - R$ ${item.valor.toLocaleString('pt-BR', {
              minimumFractionDigits: 2,
            })}`;
          },
        },
      },
    });
  }, [relatorioFaturamento]);

  return (
    <div className="row mt-4 g-3">
      {/* Tabela Valores Absolutos */}
      <div className="col-md-3">
        <div className="card shadow-sm">
          <div className="card-header bg-success text-white">
            <h5 className="mb-0">VALOR A FATURAR (R$)</h5>
          </div>
          <div className="card-body p-0 table-responsive">
            <table className="table table-striped table-bordered mb-0">
              <tbody>
                {dadosResumo.map(({ categoria, valor }) => (
                  <tr key={categoria}>
                    <td>{categoria}</td>
                    <td className="text-end fw-bold">
                      R$ {valor.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
                    </td>
                  </tr>
                ))}
                <tr className="table-primary fw-bold">
                  <td>Total Geral</td>
                  <td className="text-end">
                    R$ {totalGeral.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Tabela Percentuais */}
      <div className="col-md-3">
        <div className="card shadow-sm">
          <div className="card-header bg-info text-white">
            <h5 className="mb-0">VALOR A FATURAR (%)</h5>
          </div>
          <div className="card-body p-0 table-responsive">
            <table className="table table-striped table-bordered mb-0">
              <tbody>
                {dadosResumo.map(({ categoria, percentual }) => (
                  <tr key={categoria}>
                    <td>{categoria}</td>
                    <td className="text-end fw-bold">{percentual}%</td>
                  </tr>
                ))}
                <tr className="table-primary fw-bold">
                  <td>Total Geral</td>
                  <td className="text-end">100%</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Gráfico Pizza */}
      <div className="col-md-6">
        <div className="card shadow-sm" style={{ minHeight: '400px' }}>
          <div className="card-header bg-primary text-white">
            <h5 className="mb-0">Distribuição por Status de Faturamento</h5>
          </div>
          <div className="card-body d-flex justify-content-center align-items-center">
            {series.length ? (
              <ReactApexChart
                options={{
                  ...opcoes,
                  chart: { ...opcoes.chart, height: 800 }, // altura maior fixa
                  legend: { ...opcoes.legend, position: 'bottom' }, // legenda abaixo
                }}
                series={series}
                type="pie"
                height={800} // aumenta altura real do gráfico
                width="100%" // ocupa toda largura
              />
            ) : (
              <p className="text-muted text-center py-5">Nenhum dado disponível para exibir</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

PainelGraficosFAT.propTypes = {
  relatorioFaturamento: PropTypes.array.isRequired,
};

export default PainelGraficosFAT;
