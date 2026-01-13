using UserApi.DTOs;
using UserApi.Repositories;

namespace UserApi.Services;

public class UserService : IUserService
{
    private readonly IUserRepository _repository;

    public UserService(IUserRepository repository)
    {
        _repository = repository;
    }

    public async Task CreateUserAsync(UserCreateDto dto)
    {
        await _repository.CreateUserAsync(
            dto.Nombre,
            dto.Telefono,
            dto.Direccion,
            dto.PaisId,
            dto.DepartamentoId,
            dto.MunicipioId
        );
    }
}
