/*
  This File Is Part Of Whedcapp - Well-Being Health Environment Data Collection App - to collect self-evaluated data for research purpose
  Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

  Whedcapp is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Whedcapp is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.
*/
#ifndef GENERATOR_PROTO_HH
#define GENERATOR_PROTO_HH
#include <memory>
#include "driver.hh"
#include "igenerator.hh"
#include "options.hh"
#include "type.hh"

namespace PartSqlCrudGen {
  class GclpColumnParametersWithTypeInformationInParameterList;
  class GclpColumnParametersForSelectInParameterList;
  class GclpColumnParametersIncludingIdForSelect;
  class GeneratorProto: public IGenerator {
    friend GclpColumnParametersWithTypeInformationInParameterList;
    friend GclpColumnParametersForSelectInParameterList;
    friend GclpColumnParametersIncludingIdForSelect;
  private:
    static std::map<Type,std::string> type2protoType;
    std::ostream& generateRpcIngress(std::ostream& str,
                                     const Options& options,
                                     const std::shared_ptr<Driver>& shPtr2Driver) const;
    std::ostream& generateRpcStdMsg(std::ostream& str,
                                    const Options& options,
                                    const std::shared_ptr<Driver>& shPtr2Driver) const;
    std::ostream& generateRpc(std::ostream& str,
                              const Options& options,
                              const std::shared_ptr<Driver>& shPtr2Driver,
                              const ShPtr2Table& tableMetaData,
                              const DatabaseOperation::Type& op,
                              const Access::Type& accessType) const;
    std::ostream& generateRpcApi(std::ostream& str,
                                 const Options& options,
                                 const std::shared_ptr<Driver>& shPtr2Driver) const;
    std::ostream& generateInpMsgCtxtPar(std::ostream& str,
                                        const Options& options,
                                        const std::shared_ptr<Driver>& shPtr2Driver,
                                        const ShPtr2Table& tableMetaData,
                                        const DatabaseOperation::Type& op,
                                        const Access::Type& accessType,
                                        bool selectMsg,
                                        bool& notFirstContextParameter,
                                        int& grpcPosPar) const;
    std::ostream& generateInpMsgNotCtxtPar(std::ostream& str,
                                           const Options& options,
                                           const std::shared_ptr<Driver>& shPtr2Driver,
                                           const ShPtr2Table& tableMetaData,
                                           const DatabaseOperation::Type& op,
                                           const Access::Type& accessType,
                                           bool selectMsg,
                                           bool& notFirstContextParameter,
                                           int& grpcPosPar) const;
    std::ostream& generateInpMsgPar(std::ostream& str,
                                    const Options& options,
                                    const std::shared_ptr<Driver>& shPtr2Driver,
                                    const ShPtr2Table& tableMetaData,
                                    const DatabaseOperation::Type& op,
                                    const Access::Type& accessType,
                                    bool& notFirstContextParameter,
                                    int& grpcPosPar) const;
    std::ostream& generateInpMsg(std::ostream& str,
                                 const Options& options,
                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                 const ShPtr2Table& tableMetaData,
                                 const DatabaseOperation::Type& op,
                                 const Access::Type& accessType) const;
    std::ostream& generateResMsgPar(std::ostream& str,
                                    const Options& options,
                                    const std::shared_ptr<Driver>& shPtr2Driver,
                                    const ShPtr2Table& tableMetaData,
                                    const DatabaseOperation::Type& op,
                                    const Access::Type& accessType,
                                    bool& notFirstParameter,
                                    int& grpcPosPar) const;
    std::ostream& generateResMsg(std::ostream& str,
                                 const Options& options,
                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                 const ShPtr2Table& tableMetaData,
                                 const DatabaseOperation::Type& op,
                                 const Access::Type& accessType) const;
    std::ostream& generateInpMsgs(std::ostream& str,
                                  const Options& options,
                                  const std::shared_ptr<Driver>& shPtr2Driver) const;
    
  public:
    void generate(const PartSqlCrudGen::Options& options, const std::shared_ptr<PartSqlCrudGen::Driver>& shPtr2Driver) const override;
  };
  static int dummyGrpcParPos = -1;
  class GenerateColumnListProto: public GenerateColumnList {
    
  public:
    int& grpcParPos;
    GenerateColumnListProto(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false,int& grpcParPos = dummyGrpcParPos): GenerateColumnList(str, shPtr2Table,optContextParameter,suffix, notFirst),grpcParPos(grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column)  override;
    static std::unique_ptr<IGenerateColumnList> create(IGenerateColumnList::GenerateKind generateKind,std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false, int& grpcParPos = dummyGrpcParPos);
    std::ostream& generateColumnList() override;
      
    
  };

  
  class GclpOnlyColumnParameters: public GenerateColumnListProto {
  public:
    GclpOnlyColumnParameters(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "",bool notFirst = false,int& grpcParPos = dummyGrpcParPos): GenerateColumnListProto(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    
  };

  class GclpColumnParametersWithTypeInformationInParameterList: public GclpOnlyColumnParameters {
  public:
    GclpColumnParametersWithTypeInformationInParameterList(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false,int& grpcParPos = dummyGrpcParPos): GclpOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column)  override;
  };

  class GclpColumnParametersForUpdateInParameterList: public GclpOnlyColumnParameters {
  public:
    GclpColumnParametersForUpdateInParameterList(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false, int& grpcPosPar = dummyGrpcParPos): GclpOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcPosPar) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
  };

  class GclpOnlyPrimaryKeyInParameterList: public GclpOnlyColumnParameters {
  public:
    GclpOnlyPrimaryKeyInParameterList(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false, int& grpcParPos = dummyGrpcParPos): GclpOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix, notFirst, grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    
  };


  class GclpColumnParametersForSelectInParameterList: public GclpOnlyColumnParameters {
  public:
    GclpColumnParametersForSelectInParameterList(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false, int& grpcParPos = dummyGrpcParPos): GclpOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix, notFirst, grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column) override;
    
  };

  class GclpColumnParametersIncludingIdForSelect: public GclpOnlyColumnParameters {
  public:
    GclpColumnParametersIncludingIdForSelect(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "", bool notFirst = false, int& grpcParPos = dummyGrpcParPos): GclpOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column) override;
  };


}
#endif
