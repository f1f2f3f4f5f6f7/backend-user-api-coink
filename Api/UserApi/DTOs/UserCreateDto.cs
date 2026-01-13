using System.ComponentModel.DataAnnotations;

namespace UserApi.DTOs;

public class UserCreateDto
{
    [Required(ErrorMessage = "El nombre es obligatorio")]
    [StringLength(100, ErrorMessage = "Máximo 100 caracteres")]
    public required string Nombre { get; set; }

    [Required]
    [StringLength(20)]
    public required string Telefono { get; set; }

    [Required]
    [StringLength(200)]
    public required string Direccion { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public required int PaisId { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public required int DepartamentoId { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public required int MunicipioId { get; set; }

    
}
