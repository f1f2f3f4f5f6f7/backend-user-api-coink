using UserApi.DTOs;

namespace UserApi.Services;

public interface IUserService
{
    Task CreateUserAsync(UserCreateDto dto);
}
