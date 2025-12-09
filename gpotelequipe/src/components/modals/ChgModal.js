import {
    Modal,
    ModalHeader,
    ModalBody,
    ModalFooter,
    Label,
    FormGroup,
    Input,
    Button,
} from 'reactstrap';
import PropTypes from 'prop-types';

export function ChgModal({
    open,
    onClose,
    tpForm,
    onChange,
    onCreate,
    loading,
    pai,
    empresa,
}) {
    const handleSalvar = () => {
        const id = tpForm?.id || ' ';
        onCreate(id, pai, empresa);
    };

    return (
        <Modal isOpen={open} toggle={onClose} size="xl">
            <ModalHeader toggle={onClose}>Criar CHG - {empresa}</ModalHeader>
            <ModalBody>
                <div className="container-fluid">
                    <div className="row g-3">
                        <div className="col-md-4">
                            <FormGroup>
                                <Label htmlFor="chg-site-id">Site ID</Label>
                                <Input
                                    id="chg-site-id"
                                    aria-label="Site ID"
                                    type="text"
                                    className="form-control"
                                    name="siteId"
                                    value={tpForm?.siteId ?? ''}
                                    onChange={onChange}
                                    placeholder="Site ID"
                                    disabled
                                />
                            </FormGroup>
                        </div>
                        <div className="col-md-4">
                            <FormGroup>
                                <Label htmlFor="chg-tipo">Tipo</Label>
                                <Input
                                    id="chg-tipo"
                                    aria-label="Tipo"
                                    type="select"
                                    className="form-select"
                                    name="tipo"
                                    value={tpForm?.tipo ?? ''}
                                    onChange={onChange}
                                >
                                    <option value="" disabled>
                                        Selecionar...
                                    </option>
                                    <option value="S/IMPACTO">S/IMPACTO</option>
                                    <option value="IMPACTO">IMPACTO</option>
                                </Input>
                            </FormGroup>
                        </div>

                        <div className="col-md-4">
                            <FormGroup>
                                <Label htmlFor="chg-criado-em">Criado em</Label>
                                <Input
                                    id="chg-criado-em"
                                    aria-label="Criado em"
                                    type="date"
                                    className="form-control"
                                    name="criadoEm"
                                    value={tpForm?.criadoEm ?? ''}
                                    onChange={onChange}
                                />
                            </FormGroup>
                        </div>
                    </div>

                    <div className="row g-3">
                        <div className="col-md-3">
                            <FormGroup>
                                <Label htmlFor="chg-data-inicio">Data Início</Label>
                                <Input
                                    id="chg-data-inicio"
                                    aria-label="Data Início"
                                    type="date"
                                    className="form-control"
                                    name="dataInicio"
                                    value={tpForm?.dataInicio ?? ''}
                                    onChange={onChange}
                                />
                            </FormGroup>
                        </div>

                        <div className="col-md-3">
                            <FormGroup>
                                <Label htmlFor="chg-hora-inicio">Hora Início</Label>
                                <Input
                                    id="chg-hora-inicio"
                                    aria-label="Hora Início"
                                    type="time"
                                    className="form-control"
                                    name="horaInicio"
                                    value={tpForm?.horaInicio ?? ''}
                                    onChange={onChange}
                                />
                            </FormGroup>
                        </div>

                        <div className="col-md-3">
                            <FormGroup>
                                <Label htmlFor="chg-data-fim">Data Fim</Label>
                                <Input
                                    id="chg-data-fim"
                                    aria-label="Data Fim"
                                    type="date"
                                    className="form-control"
                                    name="dataFim"
                                    value={tpForm?.dataFim ?? ''}
                                    onChange={onChange}
                                />
                            </FormGroup>
                        </div>

                        <div className="col-md-3">
                            <FormGroup>
                                <Label htmlFor="chg-hora-fim">Hora Fim</Label>
                                <Input
                                    id="chg-hora-fim"
                                    aria-label="Hora Fim"
                                    type="time"
                                    className="form-control"
                                    name="horaFim"
                                    value={tpForm?.horaFim ?? ''}
                                    onChange={onChange}
                                />
                            </FormGroup>
                        </div>
                    </div>

                    <div className="row g-3">
                        <div className="col-md-4">
                            <FormGroup>
                                <Label htmlFor="chg-numero">Número</Label>
                                <Input
                                    id="chg-numero"
                                    aria-label="Número"
                                    type="text"
                                    className="form-control"
                                    name="numero"
                                    value={tpForm?.numero ?? ''}
                                    onChange={onChange}
                                    placeholder="Ex.: CHG-0001"
                                />
                            </FormGroup>
                        </div>

                        <div className="col-md-4">
                            <FormGroup>
                                <Label htmlFor="chg-status">Status</Label>
                                <Input
                                    id="chg-status"
                                    aria-label="Status"
                                    type="select"
                                    className="form-select"
                                    name="status"
                                    value={tpForm?.status ?? ''}
                                    onChange={onChange}
                                >
                                    <option value="" disabled>
                                        Selecionar...
                                    </option>
                                    <option value="Autorizada">Autorizada</option>
                                    <option value="Cancelada">Cancelada</option>
                                    <option value="Fechado">Fechado</option>
                                    <option value="Pedir">Pedir</option>
                                    <option value="Pré-Aprovada">Pré-Aprovada</option>
                                </Input>
                            </FormGroup>
                        </div>
                    </div>
                </div>
            </ModalBody>
            <ModalFooter className="d-flex">
                <Button
                    color="primary"
                    onClick={handleSalvar}
                    disabled={loading}
                    className="ms-auto"
                >
                    {loading ? 'Salvando...' : 'Salvar CHG'}
                </Button>
                <Button color="secondary" onClick={onClose}>
                    Cancelar
                </Button>
            </ModalFooter>
        </Modal>
    );
}

ChgModal.propTypes = {
    open: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    tpForm: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCreate: PropTypes.func.isRequired,
    loading: PropTypes.bool,
    pai: PropTypes.string,
    empresa: PropTypes.string,
};

export default ChgModal;
