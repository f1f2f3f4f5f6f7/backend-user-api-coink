using Microsoft.AspNetCore.Mvc;
using Npgsql;
using UserApi.DTOs;
using UserApi.Services;

namespace UserApi.Controllers;

[ApiController]
[Route("api/usuarios")]
public class UsersController : ControllerBase
{
    private readonly IUserService _service;

    public UsersController(IUserService service)
    {
        _service = service;
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] UserCreateDto dto)
    {
        try
        {
            await _service.CreateUserAsync(dto);
            return StatusCode(201); // Created
        }
        catch (Npgsql.PostgresException ex) when (ex.SqlState == "P0001")
        {
            // Error lanzado por RAISE EXCEPTION en el SP
            return BadRequest(new { error = ex.MessageText });
        }
        catch (Npgsql.PostgresException ex) when (ex.SqlState == "23503")
        {
            // FK violation
            return BadRequest(new { error = "Ubicación inválida" });
        }
        catch (Exception)
        {
            return StatusCode(500, new { error = "Error interno del servidor" });
        }
    }
}
