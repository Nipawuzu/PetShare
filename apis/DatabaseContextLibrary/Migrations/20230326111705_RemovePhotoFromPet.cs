using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DatabaseContextLibrary.Migrations
{
    /// <inheritdoc />
    public partial class RemovePhotoFromPet : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Photo",
                table: "Pets");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<byte[]>(
                name: "Photo",
                table: "Pets",
                type: "varbinary(max)",
                nullable: true);
        }
    }
}
