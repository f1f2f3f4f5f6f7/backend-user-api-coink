namespace UserApi.Repositories;

public interface IUserRepository
{
    Task CreateUserAsync(
        string nombre,
        string telefono,
        string direccion,
        int paisId,
        int departamentoId,
        int municipioId
    );
}
