import React, { useState, useEffect, useCallback } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import '../modernDashboard/SalesMonth.scss';
import PessoaModal from './PessoaModal';
import Loader from '../../../layouts/loader/Loader';
import api from '../../../services/api';
import exportExcel from '../../../data/exportexcel/Excelexport';

const Isignum = () => {
    const [loading, setLoading] = useState(true);
    const [validos, setValidos] = useState([]);
    const [inativosState, setInativosState] = useState([]);
    const [aVencer, setAVencer] = useState([]);
    const [isOpen, setIsOpen] = useState(false);
    const [modalData, setModalData] = useState([]);
    const [modalTitle, setModalTitle] = useState('');
    const [totalCount, setTotalCount] = useState(0);
    const [porcentagemValidos, setPorcentagemValidos] = useState(0);

    const toggle = () => setIsOpen(!isOpen);

    const handleLegendClick = (status) => {
        let data = [];
        let title = '';
        switch (status) {
            case 'Ativos':
                data = validos;
                title = 'Ativos';
                break;
            case 'Inativos':
                data = inativosState;
                title = 'Inativos';
                break;
            case 'A vencer':
                data = aVencer;
                title = 'A vencer';
                break;
            default:
                break;
        }
        setModalData(data);
        setModalTitle(title);
        setIsOpen(true);
    };

    const fetchData = useCallback(async () => {
        try {
            const { data } = await api.get('/v1/pessoa');

            const validosData = [];
            const inativosData = [];
            const aVencerData = [];
            const currentDate = new Date();
            //console.log("o que vem em isignum vi/pessoa: ", data);

            data.forEach(person => {
                if (person.status === "INATIVO") return;
                if (person.inativacao && person.inativacao !== '1899-12-30') {
                    const inativacaoDate = new Date(person.inativacao);
                    const timeDifference = inativacaoDate - currentDate;
                    const daysToExpire = timeDifference / (1000 * 3600 * 24);

                    if (daysToExpire < 0) {
                        inativosData.push(person);
                    } else if (daysToExpire <= 30) {
                        aVencerData.push(person);
                    } else {
                        validosData.push(person);
                    }
                }
            });

            setValidos(validosData);
            setInativosState(inativosData);
            setAVencer(aVencerData);

            const total = validosData.length + inativosData.length + aVencerData.length;
            setTotalCount(total);
            setPorcentagemValidos((validosData.length / total) * 100);

            setLoading(false);
        } catch (error) {
            console.error('Error fetching pessoa data:', error);
        }
    }, []);

    useEffect(() => {
        fetchData();
    }, [fetchData]);

    const gerarexcel = () => {
        const excelData = [...validos, ...inativosState, ...aVencer].map((item) => {
            return {
                Nome: item.nome,
                'Data de Inativação': item.inativacao,
                Situação: item.situacao,
            };
        });
        exportExcel({ excelData, fileName: 'Isignum' });
    };

    const series = [validos.length, inativosState.length, aVencer.length];
    const options = {
        labels: ['Ativos', 'Inativos', 'A vencer'],
        chart: {
            type: 'donut',
            events: {
                legendClick(seriesIndex) {
                    switch (seriesIndex) {
                        case 0:
                            handleLegendClick('Ativos');
                            break;
                        case 1:
                            handleLegendClick('Inativos');
                            break;
                        case 2:
                            handleLegendClick('A vencer');
                            break;
                        default:
                            break;
                    }
                }
            }
        },
        colors: ['#007bff', '#FF0000', '#FFA500'],
        legend: {
            show: false
        }
    };

    if (loading) {
        return <Loader />;
    }

    return (
        <>
            <DashCard title="Isignum" actions={
                <Button color="link" onClick={() => gerarexcel()}>
                    Exportar Excel
                </Button>
            }>
                <Row className="mt-4">
                    <Col md="7">
                        <div className="mt-3 position-relative" style={{ height: '250px' }}>
                            <Chart options={options} series={series} type="donut" height="250" />
                        </div>
                    </Col>
                    <Col md="5">
                        <h2 className="mb-1 mt-3 fs-1">{Number(porcentagemValidos).toFixed(2)} %</h2>
                        <span className="text-muted">{totalCount} Pessoas</span>
                        <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
                            <div className="d-flex align-items-center">
                            <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>
                                <Button color='white' onClick={() => handleLegendClick('Ativos')} className="uniform-button">Ativos</Button>
                            </div>
                            <div className="d-flex align-items-center">
                                <i className="bi bi-circle-fill fs-6 me-2 text-warning"></i>
                                <Button color='white' onClick={() => handleLegendClick('A vencer')} className="uniform-button">A Vencer</Button>
                            </div>
                            <div className="d-flex align-items-center">
                                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                                <Button color='white' onClick={() => handleLegendClick('Inativos')} className="uniform-button">Inativos</Button>
                            </div>
                        </div>
                    </Col>
                </Row>
            </DashCard>
            <PessoaModal isOpen={isOpen} toggle={toggle} data={modalData} title={modalTitle} />
        </>
    );
};

export default Isignum;