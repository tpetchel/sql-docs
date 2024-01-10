---
title: Get started with SQL Server Linux containers on Docker
titleSuffix: SQL Server
description: This quickstart shows how to use Docker to run the SQL Server 2017 and 2019 container images. You then create and query a database with sqlcmd.
author: vin-yu 
ms.author: vinsonyu
ms.reviewer: vanto
ms.date: 05/14/2019
ms.topic: conceptual
ms.prod: sql
ms.technology: linux
ms.custom: "sqlfreshmay19"
ms.prod_service: linux
ms.assetid: 82737f18-f5d6-4dce-a255-688889fdde69
moniker: ">= sql-server-linux-2017 || >= sql-server-2017 || =sqlallproducts-allversions"
zone_pivot_groups: cs1-command-shell
---

# Quickstart: Run SQL Server container images with Docker

[!INCLUDE[appliesto-ss-xxxx-xxxx-xxx-md-linuxonly](../includes/appliesto-ss-xxxx-xxxx-xxx-md-linuxonly.md)]

<!--SQL Server 2017 on Linux-->
::: moniker range="= sql-server-linux-2017 || = sql-server-2017"

In this quickstart, you use Docker to pull and run the SQL Server 2017 container image, [mssql-server-linux](https://hub.docker.com/_/microsoft-mssql-server). Then connect with **sqlcmd** to create your first database and run queries.

> [!TIP]
> If you want to try the SQL Server 2019 preview image, see the [SQL Server 2019 preview version of this article](quickstart-install-connect-docker.md?view=sql-server-linux-ver15).

::: moniker-end
<!--SQL Server 2019 on Linux-->
::: moniker range=">= sql-server-linux-ver15 || >= sql-server-ver15 || =sqlallproducts-allversions"

In this quickstart, you use Docker to pull and run the SQL Server 2019 preview container image, [mssql-server](https://hub.docker.com/r/microsoft/mssql-server). Then connect with **sqlcmd** to create your first database and run queries.

> [!TIP]
> This quickstart creates SQL Server 2019 preview containers. If you prefer to create SQL Server 2017 containers, see the [SQL Server 2017 version of this article](quickstart-install-connect-docker.md?view=sql-server-linux-2017).
::: moniker-end

This image consists of SQL Server running on Linux based on Ubuntu 16.04. It can be used with the Docker Engine 1.8+ on Linux or on Docker for Mac/Windows. This quickstart specifically focuses on using the SQL Server on **linux** image. The Windows image is not covered, but you can learn more about it on the [mssql-server-windows-developer Docker Hub page](https://hub.docker.com/r/microsoft/mssql-server-windows-developer/).

## <a id="requirements"></a> Prerequisites

- Docker Engine 1.8+ on any supported Linux distribution or Docker for Mac/Windows. For more information, see [Install Docker](https://docs.docker.com/engine/installation/).
- Docker **overlay2** storage driver. This is the default for most users. If you find that you are not using this storage provider and need to change, please see the instructions and warnings in the [docker documentation for configuring overlay2](https://docs.docker.com/storage/storagedriver/overlayfs-driver/#configure-docker-with-the-overlay-or-overlay2-storage-driver).
- Minimum of 2 GB of disk space.
- Minimum of 2 GB of RAM.
- [System requirements for SQL Server on Linux](sql-server-linux-setup.md#system).

<!--The following H2 is versioned for 2017 and 2019. Much of the content is duplicated, so
any changes to one section should be duplicated in the other-->
::: moniker range="= sql-server-linux-2017 || = sql-server-2017"

## <a id="pullandrun2017"></a> Pull and run the container image

Before starting the following steps, make sure that you have selected your preferred shell (bash, PowerShell, or cmd) at the top of this article.

1. Pull the SQL Server 2017 Linux container image from Microsoft Container Registry.

   ::: zone pivot="cs1-bash"
   <!-- replaycheck-task id="80c21bf7" -->
   <!-- replaycheck-task id="b2761d46" -->
   ```bash
   sudo docker pull mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker pull mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker pull mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   > [!TIP]
   > If you want to try the SQL Server 2019 preview image, see the [SQL Server 2019 preview version of this article](quickstart-install-connect-docker.md?view=sql-server-linux-ver15#pullandrun2019).

   The previous command pulls the latest SQL Server 2017 container image. If you want to pull a specific image, you add a colon and the tag name (for example, `mcr.microsoft.com/mssql/server:2017-GA-ubuntu`). To see all available images, see [the mssql-server Docker hub page](https://hub.docker.com/r/microsoft/mssql-server).

   ::: zone pivot="cs1-bash"
   For the bash commands in this article, `sudo` is used. On MacOS, `sudo` might not be required. On Linux, if you do not want to use `sudo` to run Docker, you can configure a **docker** group and add users to that group. For more information, see [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).
   ::: zone-end

2. To run the container image with Docker, you can use the following command from a bash shell (Linux/macOS) or elevated PowerShell command prompt.

   ::: zone pivot="cs1-bash"
   <!-- replaycheck-task id="79de2388" -->
   ```bash
   sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" \
      -p 1433:1433 --name sql1 \
      -d mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" `
      -p 1433:1433 --name sql1 `
      -d mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" `
      -p 1433:1433 --name sql1 `
      -d mcr.microsoft.com/mssql/server:2017-latest
   ```
   ::: zone-end

   > [!NOTE]
   > The password should follow the SQL Server default password policy, otherwise the container can not setup SQL server and will stop working. By default, the password must be at least 8 characters long and contain characters from three of the following four sets: Uppercase letters, Lowercase letters, Base 10 digits, and Symbols. You can examine the error log by executing the [docker logs](https://docs.docker.com/engine/reference/commandline/logs/) command.

   > [!NOTE]
   > By default, this creates a container with the Developer edition of SQL Server 2017. The process for running production editions in containers is slightly different. For more information, see [Run production container images](sql-server-linux-configure-docker.md#production).

   The following table provides a description of the parameters in the previous `docker run` example:

   | Parameter | Description |
   |-----|-----|
   | **-e 'ACCEPT_EULA=Y'** |  Set the **ACCEPT_EULA** variable to any value to confirm your acceptance of the [End-User Licensing Agreement](https://go.microsoft.com/fwlink/?LinkId=746388). Required setting for the SQL Server image. |
   | **-e 'SA_PASSWORD=\<YourStrong!Passw0rd\>'** | Specify your own strong password that is at least 8 characters and meets the [SQL Server password requirements](../relational-databases/security/password-policy.md). Required setting for the SQL Server image. |
   | **-p 1433:1433** | Map a TCP port on the host environment (first value) with a TCP port in the container (second value). In this example, SQL Server is listening on TCP 1433 in the container and this is exposed to the port, 1433, on the host. |
   | **--name sql1** | Specify a custom name for the container rather than a randomly generated one. If you run more than one container, you cannot reuse this same name. |
   | **mcr.microsoft.com/mssql/server:2017-latest** | The SQL Server 2017 Linux container image. |

3. To view your Docker containers, use the `docker ps` command.


   ::: zone pivot="cs1-bash"
   <!-- replaycheck-task id="764d1672" -->
   ```bash
   sudo docker ps -a
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker ps -a
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker ps -a
   ```
   ::: zone-end

   You should see output similar to the following screenshot:

   ![Docker ps command output](./media/sql-server-linux-setup-docker/docker-ps-command.png)

4. If the **STATUS** column shows a status of **Up**, then SQL Server is running in the container and listening on the port specified in the **PORTS** column. If the **STATUS** column for your SQL Server container shows **Exited**, see the [Troubleshooting section of the configuration guide](sql-server-linux-configure-docker.md#troubleshooting).

The `-h` (host name) parameter is also useful, but it is not used in this tutorial for simplicity. This changes the internal name of the container to a custom value. This is the name you'll see returned in the following Transact-SQL query:

<!-- replaycheck-task id="966c8385" -->
```sql
SELECT @@SERVERNAME,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),
    SERVERPROPERTY('MachineName'),
    SERVERPROPERTY('ServerName')
```

Setting `-h` and `--name` to the same value is a good way to easily identify the target container.

::: moniker-end
<!--End of 2017 "Pull and run" section-->

<!--This is the 2019 version of the "Pull and run" section-->
::: moniker range=">= sql-server-linux-ver15 || >= sql-server-ver15 || =sqlallproducts-allversions"

## <a id="pullandrun2019"></a> Pull and run the container image

Before starting the following steps, make sure that you have selected your preferred shell (bash, PowerShell, or cmd) at the top of this article.

1. Pull the SQL Server 2019 preview Linux container image from Docker Hub.

   ::: zone pivot="cs1-bash"
   ```bash
   sudo docker pull mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker pull mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker pull mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   > [!TIP]
   > This quickstart uses the SQL Server 2019 preview Docker image. If you want to run the SQL Server 2017 image, see the [SQL Server 2017 version of this article](quickstart-install-connect-docker.md?view=sql-server-linux-2017#pullandrun2017).

   The previous command pulls the SQL Server 2019 preview container image based on Ubuntu. To instead use container images based on RedHat, see [Run RHEL-based container images](sql-server-linux-configure-docker.md#rhel). To see all available images, see [the mssql-server-linux Docker hub page](https://hub.docker.com/_/microsoft-mssql-server).

   ::: zone pivot="cs1-bash"
   For the bash commands in this article, `sudo` is used. On MacOS, `sudo` might not be required. On Linux, if you do not want to use `sudo` to run Docker, you can configure a **docker** group and add users to that group. For more information, see [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/).
   ::: zone-end

2. To run the container image with Docker, you can use the following command from a bash shell (Linux/macOS) or elevated PowerShell command prompt.

   ::: zone pivot="cs1-bash"
   ```bash
   sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" \
      -p 1433:1433 --name sql1 \
      -d mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" `
      -p 1433:1433 --name sql1 `
      -d mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong!Passw0rd>" `
      -p 1433:1433 --name sql1 `
      -d mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu
   ```
   ::: zone-end

   > [!NOTE]
   > The password should follow the SQL Server default password policy, otherwise the container can not setup SQL server and will stop working. By default, the password must be at least 8 characters long and contain characters from three of the following four sets: Uppercase letters, Lowercase letters, Base 10 digits, and Symbols. You can examine the error log by executing the [docker logs](https://docs.docker.com/engine/reference/commandline/logs/) command.

   > [!NOTE]
   > By default, this creates a container with the Developer edition of SQL Server 2019 preview.

   The following table provides a description of the parameters in the previous `docker run` example:

   | Parameter | Description |
   |-----|-----|
   | **-e 'ACCEPT_EULA=Y'** |  Set the **ACCEPT_EULA** variable to any value to confirm your acceptance of the [End-User Licensing Agreement](https://go.microsoft.com/fwlink/?LinkId=746388). Required setting for the SQL Server image. |
   | **-e 'SA_PASSWORD=\<YourStrong!Passw0rd\>'** | Specify your own strong password that is at least 8 characters and meets the [SQL Server password requirements](../relational-databases/security/password-policy.md). Required setting for the SQL Server image. |
   | **-p 1433:1433** | Map a TCP port on the host environment (first value) with a TCP port in the container (second value). In this example, SQL Server is listening on TCP 1433 in the container and this is exposed to the port, 1433, on the host. |
   | **--name sql1** | Specify a custom name for the container rather than a randomly generated one. If you run more than one container, you cannot reuse this same name. |
   | **mcr.microsoft.com/mssql/server:2019-CTP3.1-ubuntu** | The SQL Server 2019 CTP3.1 Linux container image. |

3. To view your Docker containers, use the `docker ps` command.

   ::: zone pivot="cs1-bash"
   ```bash
   sudo docker ps -a
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker ps -a
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker ps -a
   ```
   ::: zone-end

   You should see output similar to the following screenshot:

   ![Docker ps command output](./media/sql-server-linux-setup-docker/docker-ps-command.png)

4. If the **STATUS** column shows a status of **Up**, then SQL Server is running in the container and listening on the port specified in the **PORTS** column. If the **STATUS** column for your SQL Server container shows **Exited**, see the [Troubleshooting section of the configuration guide](sql-server-linux-configure-docker.md#troubleshooting).

The `-h` (host name) parameter is also useful, but it is not used in this tutorial for simplicity. This changes the internal name of the container to a custom value. This is the name you'll see returned in the following Transact-SQL query:

```sql
SELECT @@SERVERNAME,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),
    SERVERPROPERTY('MachineName'),
    SERVERPROPERTY('ServerName')
```

Setting `-h` and `--name` to the same value is a good way to easily identify the target container.

::: moniker-end
<!--End of 2019 "Pull and run" section-->

## <a id="sapassword"></a> Change the SA password

<!-- This section was pasted in from includes/sql-server-linux-change-docker-password.md, to better support zone pivots. 2019/02/11 -->

The **SA** account is a system administrator on the SQL Server instance that gets created during setup. After creating your SQL Server container, the `MSSQL_SA_PASSWORD` environment variable you specified is discoverable by running `echo $MSSQL_SA_PASSWORD` in the container. For security purposes, change your SA password.

1. Choose a strong password to use for the SA user.

1. Use `docker exec` to run **sqlcmd** to change the password using Transact-SQL. In the following example, replace the old password, `<YourStrong!Passw0rd>`, and the new password, `<YourNewStrong!Passw0rd>`, with your own password values.

   ::: zone pivot="cs1-bash"
   <!-- replaycheck-task id="b8d74d3f" -->
   ```bash
   sudo docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U SA -P "<YourStrong!Passw0rd>" \
      -Q 'ALTER LOGIN SA WITH PASSWORD="<YourNewStrong!Passw0rd>"'
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `
      -S localhost -U SA -P "<YourStrong!Passw0rd>" `
      -Q "ALTER LOGIN SA WITH PASSWORD='<YourNewStrong!Passw0rd>'"
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `
      -S localhost -U SA -P "<YourStrong!Passw0rd>" `
      -Q "ALTER LOGIN SA WITH PASSWORD='<YourNewStrong!Passw0rd>'"
   ```
   ::: zone-end

## Connect to SQL Server

The following steps use the SQL Server command-line tool, **sqlcmd**, inside the container to connect to SQL Server.

1. Use the `docker exec -it` command to start an interactive bash shell inside your running container. In the following example `sql1` is name specified by the `--name` parameter when you created the container.

   ::: zone pivot="cs1-bash"
   ```bash
   sudo docker exec -it sql1 "bash"
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   docker exec -it sql1 "bash"
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   docker exec -it sql1 "bash"
   ```
   ::: zone-end

2. Once inside the container, connect locally with sqlcmd. Sqlcmd is not in the path by default, so you have to specify the full path.

   <!-- replaycheck-task id="c6e3998c" -->
   ```bash
   /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<YourNewStrong!Passw0rd>"
   ```

   > [!TIP]
   > You can omit the password on the command-line to be prompted to enter it.

3. If successful, you should get to a **sqlcmd** command prompt: `1>`.

## Create and query data

The following sections walk you through using **sqlcmd** and Transact-SQL to create a new database, add data, and run a simple query.

### Create a new database

The following steps create a new database named `TestDB`.

1. From the **sqlcmd** command prompt, paste the following Transact-SQL command to create a test database:

   <!-- replaycheck-task id="e0f8f97f" -->
   ```sql
   CREATE DATABASE TestDB
   ```

2. On the next line, write a query to return the name of all of the databases on your server:

   <!-- replaycheck-task id="f9281e0e" -->
   ```sql
   SELECT Name from sys.Databases
   ```

3. The previous two commands were not executed immediately. You must type `GO` on a new line to execute the previous commands:

   <!-- replaycheck-task id="f39b2fbf" -->
   ```sql
   GO
   ```

### Insert data

Next create a new table, `Inventory`, and insert two new rows.

1. From the **sqlcmd** command prompt, switch context to the new `TestDB` database:

   <!-- replaycheck-task id="b33756a" -->
   ```sql
   USE TestDB
   ```

2. Create new table named `Inventory`:

   <!-- replaycheck-task id="507853" -->
   ```sql
   CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
   ```

3. Insert data into the new table:

   <!-- replaycheck-task id="6d45ed7" -->
   ```sql
   INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
   ```

4. Type `GO` to execute the previous commands:

   <!-- replaycheck-task id="1a74f0f4" -->
   ```sql
   GO
   ```

### Select data

Now, run a query to return data from the `Inventory` table.

1. From the **sqlcmd** command prompt, enter a query that returns rows from the `Inventory` table where the quantity is greater than 152:

   <!-- replaycheck-task id="10a7fc1a" -->
   ```sql
   SELECT * FROM Inventory WHERE quantity > 152;
   ```

2. Execute the command:

   <!-- replaycheck-task id="157da977" -->
   ```sql
   GO
   ```

### Exit the sqlcmd command prompt

1. To end your **sqlcmd** session, type `QUIT`:

   <!-- replaycheck-task id="2c260148" -->
   ```sql
   QUIT
   ```

2. To exit the interactive command-prompt in your container, type `exit`. Your container continues to run after you exit the interactive bash shell.

## <a id="connectexternal"></a> Connect from outside the container

You can also connect to the SQL Server instance on your Docker machine from any external Linux, Windows, or macOS tool that supports SQL connections.

The following steps use **sqlcmd** outside of your container to connect to SQL Server running in the container. These steps assume that you already have the SQL Server command-line tools installed outside of your container. The same principles apply when using other tools, but the process of connecting is unique to each tool.

1. Find the IP address for the machine that hosts your container. On Linux, use **ifconfig** or **ip addr**. On Windows, use **ipconfig**.

1. For this example, install the **sqlcmd** tool on your client machine. For more information, see [Install sqlcmd on Windows](../tools/sqlcmd-utility.md) or [Install sqlcmd on Linux](sql-server-linux-setup-tools.md).

1. Run sqlcmd specifying the IP address and the port mapped to port 1433 in your container. In this example, that is the same port, 1433, on the host machine. If you specified a different mapped port on the host machine, you would use it here.

   ::: zone pivot="cs1-bash"
   ```bash
   sqlcmd -S <ip_address>,1433 -U SA -P "<YourNewStrong!Passw0rd>"
   ```
   ::: zone-end

   ::: zone pivot="cs1-powershell"
   ```PowerShell
   sqlcmd -S <ip_address>,1433 -U SA -P "<YourNewStrong!Passw0rd>"
   ```
   ::: zone-end

   ::: zone pivot="cs1-cmd"
   ```cmd
   sqlcmd -S <ip_address>,1433 -U SA -P "<YourNewStrong!Passw0rd>"
   ```
   ::: zone-end

1. Run Transact-SQL commands. When finished, type `QUIT`.

Other common tools to connect to SQL Server include:

- [Visual Studio Code](sql-server-linux-develop-use-vscode.md)
- [SQL Server Management Studio (SSMS) on Windows](sql-server-linux-manage-ssms.md)
- [Azure Data Studio](../azure-data-studio/what-is.md)
- [mssql-cli (Preview)](https://github.com/dbcli/mssql-cli/blob/master/doc/usage_guide.md)
- [PowerShell Core](sql-server-linux-manage-powershell-core.md)

## Remove your container

If you want to remove the SQL Server container used in this tutorial, run the following commands:

::: zone pivot="cs1-bash"
<!-- replaycheck-task id="4f388969" -->
```bash
sudo docker stop sql1
sudo docker rm sql1
```
::: zone-end

::: zone pivot="cs1-powershell"
```PowerShell
docker stop sql1
docker rm sql1
```
::: zone-end

::: zone pivot="cs1-cmd"
```cmd
docker stop sql1
docker rm sql1
```
::: zone-end

> [!WARNING]
> Stopping and removing a container permanently deletes any SQL Server data in the container. If you need to preserve your data, [create and copy a backup file out of the container](tutorial-restore-backup-in-sql-server-container.md) or use a [container data persistence technique](sql-server-linux-configure-docker.md#persist).

## Docker demo

After you have tried using the SQL Server container image for Docker, you might want to know how Docker is used to improve development and testing. The following video shows how Docker can be used in a continuous integration and deployment scenario.

> [!VIDEO https://channel9.msdn.com/Events/Connect/2017/T152/player]

## Next steps

For a tutorial on how to restore database backup files into a container, see [Restore a SQL Server database in a Linux Docker container](tutorial-restore-backup-in-sql-server-container.md). To explore other scenarios, such as running multiple containers, data persistence, and troubleshooting, see [Configure SQL Server container images on Docker](sql-server-linux-configure-docker.md).

Also, check out the [mssql-docker GitHub repository](https://github.com/Microsoft/mssql-docker) for resources, feedback, and known issues.
