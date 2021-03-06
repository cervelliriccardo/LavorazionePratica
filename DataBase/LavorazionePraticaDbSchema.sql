USE [master]
GO
/****** Object:  Database [LavorazionePratica]    Script Date: 24/04/2016 11:31:11 ******/
CREATE DATABASE [LavorazionePratica]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LavorazionePratica', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\LavorazionePratica.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LavorazionePratica_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\LavorazionePratica_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [LavorazionePratica] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LavorazionePratica].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LavorazionePratica] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LavorazionePratica] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LavorazionePratica] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LavorazionePratica] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LavorazionePratica] SET ARITHABORT OFF 
GO
ALTER DATABASE [LavorazionePratica] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LavorazionePratica] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LavorazionePratica] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LavorazionePratica] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LavorazionePratica] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LavorazionePratica] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LavorazionePratica] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LavorazionePratica] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LavorazionePratica] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LavorazionePratica] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LavorazionePratica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LavorazionePratica] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LavorazionePratica] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LavorazionePratica] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LavorazionePratica] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LavorazionePratica] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LavorazionePratica] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LavorazionePratica] SET RECOVERY FULL 
GO
ALTER DATABASE [LavorazionePratica] SET  MULTI_USER 
GO
ALTER DATABASE [LavorazionePratica] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LavorazionePratica] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LavorazionePratica] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LavorazionePratica] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LavorazionePratica] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'LavorazionePratica', N'ON'
GO
ALTER DATABASE [LavorazionePratica] SET QUERY_STORE = OFF
GO
USE [LavorazionePratica]
GO
/****** Object:  Table [dbo].[Attributi]    Script Date: 24/04/2016 11:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attributi](
	[idAttributo] [int] IDENTITY(1,1) NOT NULL,
	[Categoria] [int] NOT NULL,
	[Descrizione] [nvarchar](50) NOT NULL,
	[HasValue] [bit] NOT NULL,
	[DescrizioneValore] [nvarchar](30) NULL,
	[Cancellato] [bit] NOT NULL,
	[IdUtenteCancellazione] [int] NULL,
	[DataCancellazione] [datetime] NULL,
 CONSTRAINT [PK_AttributiLavorazioni] PRIMARY KEY CLUSTERED 
(
	[idAttributo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CategorieAttributi]    Script Date: 24/04/2016 11:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategorieAttributi](
	[idCategoria] [int] NOT NULL,
	[Descrizione] [nvarchar](25) NULL,
	[DescrizioneInterna] [nvarchar](50) NULL,
	[Cancellato] [bit] NOT NULL,
	[IdUtenteCancellazione] [int] NULL,
	[DataCancellazione] [datetime] NULL,
 CONSTRAINT [PK_CategorieAttributi] PRIMARY KEY CLUSTERED 
(
	[idCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CategorieTipoLavorazioni]    Script Date: 24/04/2016 11:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategorieTipoLavorazioni](
	[TipoLavorazione] [int] NOT NULL,
	[Categoria] [int] NOT NULL,
	[Ordine] [int] NOT NULL,
 CONSTRAINT [PK_CategorieTipoLavorazioni] PRIMARY KEY CLUSTERED 
(
	[TipoLavorazione] ASC,
	[Categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EsclusioniAttributi]    Script Date: 24/04/2016 11:31:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsclusioniAttributi](
	[Attributo] [int] NOT NULL,
	[AttributoEscluso] [int] NOT NULL,
	[TipoLavorazione] [int] NOT NULL,
 CONSTRAINT [PK_EsclusioniAttributi] PRIMARY KEY CLUSTERED 
(
	[Attributo] ASC,
	[AttributoEscluso] ASC,
	[TipoLavorazione] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EsclusioniCategorie]    Script Date: 24/04/2016 11:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsclusioniCategorie](
	[Categoria] [int] NOT NULL,
	[CategoriaEsclusa] [int] NOT NULL,
	[TipoLavorazione] [int] NOT NULL,
 CONSTRAINT [PK_EsclusioniCategorie] PRIMARY KEY CLUSTERED 
(
	[Categoria] ASC,
	[CategoriaEsclusa] ASC,
	[TipoLavorazione] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LavorazioneAttributi]    Script Date: 24/04/2016 11:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LavorazioneAttributi](
	[LavorazionePratica] [int] NOT NULL,
	[AttributoLavorazione] [int] NOT NULL,
	[DataInserimento] [datetime] NOT NULL,
	[Valore] [nvarchar](100) NULL,
 CONSTRAINT [PK_LavorazioneAttributi] PRIMARY KEY CLUSTERED 
(
	[LavorazionePratica] ASC,
	[AttributoLavorazione] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LavorazioniPratiche]    Script Date: 24/04/2016 11:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LavorazioniPratiche](
	[idLavorazionePratica] [int] IDENTITY(1,1) NOT NULL,
	[idPratica] [int] NULL,
	[idPraticaInbound] [int] NULL,
	[TipoLavorazione] [int] NOT NULL,
	[DataInserimento] [datetime] NOT NULL,
	[UtenteInserimento] [int] NULL,
	[DataUltimaModifica] [datetime] NULL,
	[UtenteUltimaModifica] [int] NULL,
 CONSTRAINT [PK_LavorazioniPratiche] PRIMARY KEY CLUSTERED 
(
	[idLavorazionePratica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Pratiche]    Script Date: 24/04/2016 11:31:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pratiche](
	[NemeroPratica] [int] NOT NULL,
	[TipoContratto] [nvarchar](50) NULL,
	[CambiatoIndirizzo] [bit] NULL,
	[CambiatoTelefono] [bit] NULL,
	[CambiataEmail] [bit] NULL,
	[NuovaEmail] [nvarchar](50) NULL,
	[Rinnova] [bit] NULL,
	[NonRinnova] [bit] NULL,
	[RichiedeSconto] [bit] NULL,
	[ChiarezzaFattura] [bit] NULL,
	[QualitàServizio] [bit] NULL,
	[TempiAttesaCallCeter] [bit] NULL,
	[Consapevole] [bit] NULL,
	[Inconsapevole] [bit] NULL,
	[FatturaRicevuta] [bit] NULL,
	[FatturaNonRicevuta] [bit] NULL,
	[InvioCartaceo] [bit] NULL,
	[InvioEmail] [bit] NULL,
	[EmailInvio] [nvarchar](50) NULL,
 CONSTRAINT [PK_Pratiche] PRIMARY KEY CLUSTERED 
(
	[NemeroPratica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TipoLavorazioni]    Script Date: 24/04/2016 11:31:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoLavorazioni](
	[idTipoLavorazione] [int] NOT NULL,
	[Descrizione] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_TipoLavorazioni] PRIMARY KEY CLUSTERED 
(
	[idTipoLavorazione] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Attributi] ADD  CONSTRAINT [DF_Attributi_Cancellato]  DEFAULT ((0)) FOR [Cancellato]
GO
ALTER TABLE [dbo].[CategorieAttributi] ADD  CONSTRAINT [DF_CategorieAttributi_Cancellato]  DEFAULT ((0)) FOR [Cancellato]
GO
ALTER TABLE [dbo].[CategorieTipoLavorazioni] ADD  CONSTRAINT [DF_CategorieTipoLavorazioni_Ordine]  DEFAULT ((0)) FOR [Ordine]
GO
ALTER TABLE [dbo].[Attributi]  WITH CHECK ADD  CONSTRAINT [FK_AttributiLavorazioni_CategorieAttributi] FOREIGN KEY([Categoria])
REFERENCES [dbo].[CategorieAttributi] ([idCategoria])
GO
ALTER TABLE [dbo].[Attributi] CHECK CONSTRAINT [FK_AttributiLavorazioni_CategorieAttributi]
GO
ALTER TABLE [dbo].[CategorieTipoLavorazioni]  WITH CHECK ADD  CONSTRAINT [FK_CategorieTipoLavorazioni_Categorie] FOREIGN KEY([Categoria])
REFERENCES [dbo].[CategorieAttributi] ([idCategoria])
GO
ALTER TABLE [dbo].[CategorieTipoLavorazioni] CHECK CONSTRAINT [FK_CategorieTipoLavorazioni_Categorie]
GO
ALTER TABLE [dbo].[CategorieTipoLavorazioni]  WITH CHECK ADD  CONSTRAINT [FK_CategorieTipoLavorazioni_TipoLavorazioni] FOREIGN KEY([TipoLavorazione])
REFERENCES [dbo].[TipoLavorazioni] ([idTipoLavorazione])
GO
ALTER TABLE [dbo].[CategorieTipoLavorazioni] CHECK CONSTRAINT [FK_CategorieTipoLavorazioni_TipoLavorazioni]
GO
ALTER TABLE [dbo].[EsclusioniAttributi]  WITH CHECK ADD  CONSTRAINT [FK_EsclusioniAttributi_AttributiLavorazioni] FOREIGN KEY([Attributo])
REFERENCES [dbo].[Attributi] ([idAttributo])
GO
ALTER TABLE [dbo].[EsclusioniAttributi] CHECK CONSTRAINT [FK_EsclusioniAttributi_AttributiLavorazioni]
GO
ALTER TABLE [dbo].[EsclusioniAttributi]  WITH CHECK ADD  CONSTRAINT [FK_EsclusioniAttributi_AttributiLavorazioni1] FOREIGN KEY([AttributoEscluso])
REFERENCES [dbo].[Attributi] ([idAttributo])
GO
ALTER TABLE [dbo].[EsclusioniAttributi] CHECK CONSTRAINT [FK_EsclusioniAttributi_AttributiLavorazioni1]
GO
ALTER TABLE [dbo].[EsclusioniCategorie]  WITH CHECK ADD  CONSTRAINT [FK_EsclusioniCategorie_CategorieAttributi] FOREIGN KEY([Categoria])
REFERENCES [dbo].[CategorieAttributi] ([idCategoria])
GO
ALTER TABLE [dbo].[EsclusioniCategorie] CHECK CONSTRAINT [FK_EsclusioniCategorie_CategorieAttributi]
GO
ALTER TABLE [dbo].[EsclusioniCategorie]  WITH CHECK ADD  CONSTRAINT [FK_EsclusioniCategorie_CategorieAttributi1] FOREIGN KEY([CategoriaEsclusa])
REFERENCES [dbo].[CategorieAttributi] ([idCategoria])
GO
ALTER TABLE [dbo].[EsclusioniCategorie] CHECK CONSTRAINT [FK_EsclusioniCategorie_CategorieAttributi1]
GO
ALTER TABLE [dbo].[LavorazioneAttributi]  WITH CHECK ADD  CONSTRAINT [FK_LavorazioneAttributi_AttributiLavorazioni] FOREIGN KEY([AttributoLavorazione])
REFERENCES [dbo].[Attributi] ([idAttributo])
GO
ALTER TABLE [dbo].[LavorazioneAttributi] CHECK CONSTRAINT [FK_LavorazioneAttributi_AttributiLavorazioni]
GO
ALTER TABLE [dbo].[LavorazioneAttributi]  WITH CHECK ADD  CONSTRAINT [FK_LavorazioneAttributi_LavorazioniPratiche] FOREIGN KEY([LavorazionePratica])
REFERENCES [dbo].[LavorazioniPratiche] ([idLavorazionePratica])
GO
ALTER TABLE [dbo].[LavorazioneAttributi] CHECK CONSTRAINT [FK_LavorazioneAttributi_LavorazioniPratiche]
GO
ALTER TABLE [dbo].[LavorazioniPratiche]  WITH CHECK ADD  CONSTRAINT [FK_LavorazioniPratiche_TipoLavorazioni] FOREIGN KEY([TipoLavorazione])
REFERENCES [dbo].[TipoLavorazioni] ([idTipoLavorazione])
GO
ALTER TABLE [dbo].[LavorazioniPratiche] CHECK CONSTRAINT [FK_LavorazioniPratiche_TipoLavorazioni]
GO
USE [master]
GO
ALTER DATABASE [LavorazionePratica] SET  READ_WRITE 
GO

USE [master]
GO

CREATE LOGIN [LavorazionePratica] WITH PASSWORD=N'LavorazionePratica', DEFAULT_DATABASE=[LavorazionePratica], DEFAULT_LANGUAGE=[Italiano], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [LavorazionePratica]
GO
EXEC dbo.sp_changedbowner @loginame = N'LavorazionePratica', @map = false
GO
