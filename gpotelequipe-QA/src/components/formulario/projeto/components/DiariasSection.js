// src/components/projeto/DiariasSection.jsx
import PropTypes from 'prop-types';
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
import Pagination from '@mui/material/Pagination';
import LinearProgress from '@mui/material/LinearProgress';
import { CardBody, Button } from 'reactstrap';
import * as Icon from 'react-feather';

// Overlay "sem dados"
function CustomNoRowsOverlay() {
    return (
        <GridOverlay>
            <div>Nenhum dado encontrado.</div>
        </GridOverlay>
    );
}

// Paginação customizada (mostra total)
function CustomPagination() {
    const apiRef = useGridApiContext();
    const page = useGridSelector(apiRef, gridPageSelector);
    const pageCount = useGridSelector(apiRef, gridPageCountSelector);
    const rowCount = apiRef.current.getRowsCount?.() ?? 0;

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
            <span style={{ fontSize: 14 }}>Total de itens: {rowCount}</span>
            <Pagination
                color="primary"
                count={pageCount}
                page={page + 1}
                onChange={(_, value) => apiRef.current.setPage(value - 1)}
            />
        </Box>
    );
}

export default function DiariasSection({
    rows,
    columns,
    loading,
    paginationModel,
    onPaginationModelChange,
    onNovoCadastro,
}) {
    return (
        <div>
            <br />
            <b>Diárias</b>
            <hr style={{ marginTop: '0px', width: '100%' }} />

            <div className="row g-3">
                <CardBody className="px-4 , pb-2">
                    <div className="row g-3">
                        <div className="col-sm-6"></div>
                        <div className=" col-sm-6 d-flex flex-row-reverse">
                            <div className=" col-sm-6 d-flex flex-row-reverse">
                                <Button color="primary" onClick={onNovoCadastro}>
                                    Solicitar Diária <Icon.Plus />
                                </Button>
                            </div>
                        </div>
                    </div>

                    <br />

                    <div className="row g-3">
                        <Box sx={{ height: 400, width: '100%' }}>
                            <DataGrid
                                rows={rows}
                                columns={columns}
                                loading={loading}
                                disableSelectionOnClick
                                experimentalFeatures={{ newEditingApi: true }}
                                components={{
                                    Pagination: CustomPagination,
                                    LoadingOverlay: LinearProgress,
                                    NoRowsOverlay: CustomNoRowsOverlay,
                                }}
                                localeText={ptBR.components.MuiDataGrid.defaultProps.localeText}
                                paginationModel={paginationModel}
                                onPaginationModelChange={onPaginationModelChange}
                            />
                        </Box>
                    </div>
                </CardBody>
            </div>
        </div>
    );
}

DiariasSection.propTypes = {
    rows: PropTypes.array.isRequired,
    columns: PropTypes.array.isRequired,
    loading: PropTypes.bool,
    paginationModel: PropTypes.shape({
        pageSize: PropTypes.number.isRequired,
        page: PropTypes.number.isRequired,
    }).isRequired,
    onPaginationModelChange: PropTypes.func.isRequired,
    onNovoCadastro: PropTypes.func.isRequired,
};
